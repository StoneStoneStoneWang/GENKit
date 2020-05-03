//
//  GENAreaHeaderBridge.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/19.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENCollection
import RxCocoa
import RxSwift
import RxDataSources
import GENCocoa

@objc (GENAreaHeaderBridge)
public final class GENAreaHeaderBridge: GENBaseBridge {
    
    var viewModel: GENAreaHeaderViewModel!
    
    typealias Section = GENSectionModel<(), GENAreaHeaderBean>
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
}
// MARK: skip item 101 pagecontrol 102
extension GENAreaHeaderBridge {
    
    @objc public func createAreaHeader(_ vc: GENCollectionNoLoadingViewController) {
        
        let input = GENAreaHeaderViewModel.WLInput(modelSelect: vc.collectionView.rx.modelSelected(GENAreaHeaderBean.self),
                                                 itemSelect: vc.collectionView.rx.itemSelected)
        
        viewModel = GENAreaHeaderViewModel(input, disposed: disposed)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { ds, cv, ip, item in return vc.configCollectionViewCell(item, for: ip) })
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .tableData
            .asObservable()
            .map({ [Section(model: (), items: $0)] })
            .bind(to: vc.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposed)
        
        viewModel
            .output
            .zip
            .subscribe(onNext: { (area,ip) in
                
                vc.collectionView.deselectItem(at: ip, animated: true)
                
                vc.collectionViewSelectData(area, for: ip)
            })
            .disposed(by: disposed)
    }
    
    @objc public func addheader(_ header: GENAreaHeaderBean) {
        
        var values = viewModel.output.tableData.value
        
        values += [header]
        
        viewModel.output.tableData.accept(values)
    }
    
    @objc public func fetchHeaderCount() -> Int {
        
        return viewModel.output.tableData.value.count
    }
    @objc public func removeHeader(_ header: GENAreaHeaderBean) {
        
        var values = viewModel.output.tableData.value
        
        if let idx = values.firstIndex(where: {  $0 == header }) {
            values.remove(at: idx)
        }
        viewModel.output.tableData.accept(values)
    }
}
