//
//  GENCarouselBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2020/3/12.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENCollection
import RxCocoa
import RxSwift
import RxDataSources
import GENCocoa
import WLToolsKit
import ObjectMapper

public typealias GENCarouselAction = (_ carouse: GENCarouselBean) -> ()

@objc (GENCarouselBridge)
public final class GENCarouselBridge: GENBaseBridge {
    
    var viewModel: GENCarouselViewModel!
    
    typealias Section = GENSectionModel<(), GENCarouselBean>
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
    
    var vc: GENCollectionNoLoadingViewController!
    
    var pageControl: UIPageControl?
}

// MARK: pagecontrol 102
extension GENCarouselBridge {
    
    @objc public func createCarousel(_ vc: GENCollectionNoLoadingViewController ,carouseAction: @escaping GENCarouselAction) {
        
        if let pageControl = vc.view.viewWithTag(102) as? UIPageControl {
            
            self.pageControl = pageControl
            
            self.vc = vc
            
            let input = GENCarouselViewModel.WLInput(modelSelect: vc.collectionView.rx.modelSelected(GENCarouselBean.self),
                                                     itemSelect: vc.collectionView.rx.itemSelected)
            
            viewModel = GENCarouselViewModel(input, disposed: disposed)
            
            let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
                configureCell: { ds, cv, ip, item in return vc.configCollectionViewCell(item, for: ip)})
            
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
                .subscribe(onNext: { (carouse,ip) in
                    
                    carouseAction(carouse)
                })
                .disposed(by: disposed)
            
            viewModel
                .output
                .currentPage
                .bind(to: pageControl.rx.currentPage)
                .disposed(by: disposed)
            
        }
    }
    
    @objc public func setCarousels(_ carousels: [[String: String]]) {
        
        if let pageControl = pageControl {
            
            pageControl.numberOfPages = carousels.count
            
            var result : [GENCarouselBean] = []
            
            for carousel in carousels {
                
                let c = GENCarouselBean(JSON: carousel)!
                
                result += [c]
                
            }
            
            var mutable: [GENCarouselBean] = []
            
            for _ in 0..<999 {
                
                mutable += result
            }
            
            viewModel
                .output
                .tableData
                .accept(mutable)
        }
        
    }
    
    @objc public func setCurrentPage(_ page: Int) {
    
        viewModel.output.currentPage.accept(page)
    }
}
