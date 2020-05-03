//
//  GENCollectionSectionBridge.swift
//  GENBridge
//
//  Created by 王磊 on 2020/3/31.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import GENCollection
import RxCocoa
import RxSwift
import RxDataSources
import GENCocoa

public typealias GENCollectionSectionAction = (_ item: GENCollectionItemBean) -> ()

@objc (GENCollectionSectionBridge)
public final class GENCollectionSectionBridge: GENBaseBridge {
    
    var viewModel: GENCollectionSectionViewModel!
    
    typealias Section = GENSectionModel<GENCollectionSectionBean, GENCollectionItemBean>
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
    
    var vc: GENCollectionNoLoadingViewController!
    
}

// MARK: skip item 101 pagecontrol 102
extension GENCollectionSectionBridge {
    
    @objc public func createCollectionSection(_ vc: GENCollectionNoLoadingViewController ,sections: [GENCollectionSectionBean],sectionAction: @escaping GENCollectionSectionAction) {
        
        let input = GENCollectionSectionViewModel.WLInput(modelSelect: vc.collectionView.rx.modelSelected(GENCollectionItemBean.self),
                                                          itemSelect: vc.collectionView.rx.itemSelected,
                                                          sections: sections)
        
        viewModel = GENCollectionSectionViewModel(input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { ds, cv, ip, item in return vc.configCollectionViewCell(item, for: ip) },
            configureSupplementaryView: { ds, cv, kind, ip in return vc.configCollectionViewHeader(self.viewModel.output.collectionData.value[ip.section], for: ip)})
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .collectionData
            .map({ $0.map({ Section(model: $0, items: $0.items) }) })
            .bind(to: vc.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposed)
        
        viewModel
            .output
            .zip
            .subscribe(onNext: { (item,ip) in

                sectionAction(item)
            })
            .disposed(by: disposed)
        
    }
    
    @objc public func fetchSingleData(_ ip: IndexPath) -> GENCollectionItemBean! {
        
        guard let dataSource = dataSource else { return nil }
        
        return dataSource[ip]
    }
    
    @objc public func fetchCollectionDatas() -> [GENCollectionItemBean] {
        
        guard let viewModel = viewModel else { return [] }
        
        var mutable: [GENCollectionItemBean] = []
        
        for item in viewModel.output.collectionData.value {
            
            mutable += item.items
        }
        
        return mutable
    }
}
