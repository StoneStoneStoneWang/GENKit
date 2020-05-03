//
//  GENAboutBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/27.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENTable
import RxDataSources
import GENCocoa

@objc (GENAboutBridge)
public final class GENAboutBridge: GENBaseBridge {
    
    typealias Section = GENSectionModel<(), GENAboutType>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var viewModel: GENAboutViewModel!
}

extension GENAboutBridge {
    
    @objc public func createAbout(_ vc: GENTableNoLoadingViewController ,hasSpace: Bool) {
        
        let input = GENAboutViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(GENAboutType.self),
                                              itemSelect: vc.tableView.rx.itemSelected,
                                              hasSpace: hasSpace)
        
        viewModel = GENAboutViewModel(input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { ds, tv, ip, item in return vc.configTableViewCell(GENAboutBean.createAbout(item, title: item.title, subTitle: item.subtitle), for: ip) })
        
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
            .subscribe(onNext: { (item,ip) in
                
                vc.tableView.deselectRow(at: ip, animated: true)
                
                vc.tableViewSelectData(GENAboutBean.createAbout(item, title: item.title, subTitle: item.subtitle), for: ip)
            })
            .disposed(by: disposed)
        
        vc
            .tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposed)
    }
    
}
extension GENAboutBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return datasource[indexPath].cellHeight
    }
}
