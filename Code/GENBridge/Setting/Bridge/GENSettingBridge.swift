//
//  GENSettingBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENTable
import RxDataSources
import GENCocoa
import GENCache

@objc(GENSettingActionType)
public enum GENSettingActionType: Int ,Codable {
    
    case gotoFindPassword = 0
    
    case gotoModifyPassword = 1
    
    case logout = 2
    
    case unlogin = 3
    
    case black = 4
}

public typealias GENSettingAction = (_ action: GENSettingActionType ) -> ()

@objc (GENSettingBridge)
public final class GENSettingBridge: GENBaseBridge {
    
    typealias Section = GENSectionModel<(), GENSettingBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var viewModel: GENSettingViewModel!
    
    weak var vc: GENTableNoLoadingViewController!
}
extension GENSettingBridge {
    
    @objc public func createSetting(_ vc: GENTableNoLoadingViewController ,hasSpace: Bool,settingAction: @escaping GENSettingAction) {
        
        self.vc = vc
        
        let input = GENSettingViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(GENSettingBean.self),
                                                itemSelect: vc.tableView.rx.itemSelected, hasSpace: hasSpace)
        
        viewModel = GENSettingViewModel(input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { ds, tv, ip, item in  return vc.configTableViewCell(item, for: ip) })
        
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
            .subscribe(onNext: { (type,ip) in
                
                vc.tableView.deselectRow(at: ip, animated: true)
                
                switch type.type {
                    
                case .pwd:
                    
                    settingAction(.gotoFindPassword)
                case .password:
                    
                    settingAction(.gotoModifyPassword)
                    
                case .logout:
                    settingAction(.logout)
                    
                case .black:
                    
                    if GENAccountCache.default.isLogin() {
                        
                        settingAction(.black)
                        
                    } else {
                        
                        settingAction(.unlogin)
                        
                    }
                    
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
        vc
            .tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposed)
    }
    
    @objc public func updateCache(_ value: String ) {
        
        let values = viewModel.output.tableData.value
        
        if let idx = values.firstIndex(where: { $0.type == .clear}) {
            
            viewModel.output.tableData.value[idx].subTitle = value
            
            vc.tableView.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .none)
        }
    }
    
    @objc public func updateTableData(_ hasPlace: Bool) {
        
        viewModel.output.tableData.accept(GENSettingBean.createTabledata(hasPlace))
    }
}
extension GENSettingBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return datasource[indexPath].type.cellHeight
    }
}
