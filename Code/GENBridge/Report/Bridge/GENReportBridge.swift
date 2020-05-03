//
//  GENReportBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/9/9.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENTable
import RxDataSources
import GENCocoa
import GENHud
import RxCocoa
import RxSwift

@objc (GENReportBridge)
public final class GENReportBridge: GENBaseBridge {
    
    typealias Section = GENSectionModel<(), GENReportBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var viewModel: GENReportViewModel!
    
    weak var vc: GENTableNoLoadingViewController!
    
    var selectedReport: BehaviorRelay<String> = BehaviorRelay<String>(value: "1")
}

extension GENReportBridge {
    
    @objc public func createReport(_ vc: GENTableNoLoadingViewController ,reports: [[String: Any]],uid: String,encoded: String ,textView: UITextView ,reportAction: @escaping () -> ()) {
        
        if let completeItem = vc.navigationItem.rightBarButtonItem?.customView as? UIButton {
            
            self.vc = vc
            
            let input = GENReportViewModel.WLInput(reports: reports,
                                                 modelSelect: vc.tableView.rx.modelSelected(GENReportBean.self),
                                                 itemSelect: vc.tableView.rx.itemSelected,
                                                 completeTaps: completeItem.rx.tap.asSignal(),
                                                 uid: uid,
                                                 encode: encoded,
                                                 report: selectedReport.asDriver(),
                                                 content: textView.rx.text.orEmpty.asDriver())
            
            viewModel = GENReportViewModel(input, disposed: disposed)
            
            let dataSource = RxTableViewSectionedReloadDataSource<Section>(
                configureCell: { ds, tv, ip, item in return vc.configTableViewCell(item, for: ip)  })
            
            viewModel
                .output
                .tableData
                .asDriver()
                .map({ [Section(model: (), items: $0)]  })
                .drive(vc.tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposed)
            
            self.dataSource = dataSource
            
            viewModel
                .output
                .zip
                .subscribe(onNext: { [unowned self] (type,ip) in
                    
                    vc.view.endEditing(true)
                    
                    self.selectedReport.accept(type.type)
                    
                    let values = self.viewModel.output.tableData.value
                    
                    _ = values.map({ $0.isSelected = false })
                    
                    values[ip.row].isSelected = true
                    
                    self.viewModel.output.tableData.accept(values)
                })
                .disposed(by: disposed)
            
            vc
                .tableView
                .rx
                .setDelegate(self)
                .disposed(by: disposed)
            
            vc
                .tableView
                .rx
                .itemAccessoryButtonTapped
                .subscribe(onNext: { [unowned self] (ip) in
                    
                    self.selectedReport.accept("\(ip.section + 1)")
                    
                    let values = self.viewModel.output.tableData.value
                    
                    _ = values.map({ $0.isSelected = false })
                    
                    values[ip.row].isSelected = true
                    
                    self.viewModel.output.tableData.accept(values)
                })
                .disposed(by: disposed)
            
            // MARK: 举报点击中序列
            viewModel
                .output
                .completing
                .drive(onNext: { _ in
                    
                    vc.view.endEditing(true)
                    
                    GENHud.show(withStatus: "举报提交中...")
                    
                })
                .disposed(by: disposed)
            
            // MARK: 举报事件返回序列
            viewModel
                .output
                .completed
                .drive(onNext: {
                    
                    GENHud.pop()
                    
                    switch $0 {
                        
                    case let .failed(msg): GENHud.showInfo(msg)
                        
                    case .ok: reportAction()
                        
                    default: break
                    }
                })
                .disposed(by: disposed)
        }
        
    }
}
extension GENReportBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return vc.caculate(forCell: datasource[indexPath], for: indexPath)
    }
}
