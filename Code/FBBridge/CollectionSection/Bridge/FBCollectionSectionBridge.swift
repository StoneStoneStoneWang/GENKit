//
//  FBCollectionSectionBridge.swift
//  FBBridge
//
//  Created by 王磊 on 2020/3/31.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import FBCollection
import RxCocoa
import RxSwift
import RxDataSources
import FBCocoa

public typealias FBCollectionSectionAction = (_ item: FBCollectionItemBean) -> ()

@objc (FBCollectionSectionBridge)
public final class FBCollectionSectionBridge: FBBaseBridge {
    
    var viewModel: FBCollectionSectionViewModel!
    
    typealias Section = FBSectionModel<FBCollectionSectionBean, FBCollectionItemBean>
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
    
    var vc: FBCollectionNoLoadingViewController!
    
}

// MARK: skip item 101 pagecontrol 102
extension FBCollectionSectionBridge {
    
    @objc public func createCollectionSection(_ vc: FBCollectionNoLoadingViewController ,sections: [FBCollectionSectionBean],sectionAction: @escaping FBCollectionSectionAction) {
        
        let input = FBCollectionSectionViewModel.WLInput(modelSelect: vc.collectionView.rx.modelSelected(FBCollectionItemBean.self),
                                                          itemSelect: vc.collectionView.rx.itemSelected,
                                                          sections: sections)
        
        viewModel = FBCollectionSectionViewModel(input)
        
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
    
    @objc public func fetchSingleData(_ ip: IndexPath) -> FBCollectionItemBean! {
        
        guard let dataSource = dataSource else { return nil }
        
        return dataSource[ip]
    }
    
    @objc public func fetchCollectionDatas() -> [FBCollectionItemBean] {
        
        guard let viewModel = viewModel else { return [] }
        
        var mutable: [FBCollectionItemBean] = []
        
        for item in viewModel.output.collectionData.value {
            
            mutable += item.items
        }
        
        return mutable
    }
}
