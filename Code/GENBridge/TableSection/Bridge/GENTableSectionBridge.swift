//
//  GENTableSectionBridge.swift
//  GENBridge
//
//  Created by 王磊 on 2020/3/31.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import GENTable
import RxCocoa
import RxSwift
import RxDataSources
import GENCocoa

public typealias GENTableSectionAction = (_ item: GENTableRowBean ,_ ip: IndexPath) -> ()

@objc (GENTableSectionBridge)
public final class GENTableSectionBridge: GENBaseBridge {
    
    var viewModel: GENTableSectionViewModel!
    
    typealias Section = GENSectionModel<GENTableSectionBean, GENTableRowBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var vc: GENTableNoLoadingViewController!
    
}

extension GENTableSectionBridge {
    
    @objc public func createTableSection(_ vc: GENTableNoLoadingViewController ,sections: [GENTableSectionBean],sectionAction: @escaping GENTableSectionAction ) {
        
        self.vc = vc
        
        let input = GENTableSectionViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(GENTableRowBean.self),
                                                     itemSelect: vc.tableView.rx.itemSelected,
                                                     sections: sections)
        
        viewModel = GENTableSectionViewModel(input)
        
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
extension GENTableSectionBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let dataSource = dataSource else { return 0}
        
        return vc.caculate(forCell: dataSource[indexPath], for: indexPath)
    }
}
