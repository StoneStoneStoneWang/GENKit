//
//  FBTableSectionBridge.swift
//  FBBridge
//
//  Created by 王磊 on 2020/3/31.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import FBTable
import RxCocoa
import RxSwift
import RxDataSources
import FBCocoa

public typealias FBTableSectionAction = (_ item: FBTableRowBean ,_ ip: IndexPath) -> ()

@objc (FBTableSectionBridge)
public final class FBTableSectionBridge: FBBaseBridge {
    
    var viewModel: FBTableSectionViewModel!
    
    typealias Section = FBSectionModel<FBTableSectionBean, FBTableRowBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var vc: FBTableNoLoadingViewController!
    
}

extension FBTableSectionBridge {
    
    @objc public func createTableSection(_ vc: FBTableNoLoadingViewController ,sections: [FBTableSectionBean],sectionAction: @escaping FBTableSectionAction ) {
        
        self.vc = vc
        
        let input = FBTableSectionViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(FBTableRowBean.self),
                                                     itemSelect: vc.tableView.rx.itemSelected,
                                                     sections: sections)
        
        viewModel = FBTableSectionViewModel(input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { ds, tv, ip, item in return vc.configTableViewCell(item, for: ip) },
            titleForHeaderInSection: { ds ,section in return self.viewModel.output.tableData.value[section].title})
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .tableData
            .map({ $0.map({ Section(model: $0, items: $0.items) }) })
            .bind(to: vc.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposed)
        
        viewModel
            .output
            .zip
            .subscribe(onNext: { (item,ip) in
                
                sectionAction(item, ip)
            })
            .disposed(by: disposed)
        
        vc.tableView.rx.setDelegate(self).disposed(by: disposed)
        
    }
}
extension FBTableSectionBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let dataSource = dataSource else { return 0}
        
        return vc.caculate(forCell: dataSource[indexPath], for: indexPath)
    }
}
