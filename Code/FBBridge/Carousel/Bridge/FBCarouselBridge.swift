//
//  FBCarouselBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2020/3/12.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import FBCollection
import RxCocoa
import RxSwift
import RxDataSources
import FBCocoa
import WLToolsKit
import ObjectMapper

public typealias FBCarouselAction = (_ carouse: FBCarouselBean) -> ()

@objc (FBCarouselBridge)
public final class FBCarouselBridge: FBBaseBridge {
    
    var viewModel: FBCarouselViewModel!
    
    typealias Section = FBSectionModel<(), FBCarouselBean>
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
    
    var vc: FBCollectionNoLoadingViewController!
}

// MARK: skip item 101 pagecontrol 102
extension FBCarouselBridge {
    
    @objc public func createCarousel(_ vc: FBCollectionNoLoadingViewController ,canPageHidden: Bool ,canTimerResp: Bool,carousels: [[String: String]] ,carouseAction: @escaping FBCarouselAction) {
        
        if let pageControl = vc.view.viewWithTag(102) as? UIPageControl {
            
            pageControl.numberOfPages = carousels.count
            
            self.vc = vc
            
            let input = FBCarouselViewModel.WLInput(contentoffSetX: vc.collectionView.rx.contentOffset.map({ $0.x }),
                                                     modelSelect: vc.collectionView.rx.modelSelected(FBCarouselBean.self),
                                                     itemSelect: vc.collectionView.rx.itemSelected,
                                                     canTimerResp: canTimerResp,
                                                     currentPage: BehaviorRelay<Int>(value: 0),
                                                     carouselCount: carousels.count)
            
            viewModel = FBCarouselViewModel(input, disposed: disposed)
            
            var result : [FBCarouselBean] = []
            
            for carousel in carousels {
                
                let c = FBCarouselBean(JSON: carousel)!
                
                result += [c]
                
            }
            
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
                .timered
                .subscribe(onNext: { [unowned self] (index) in
                    
                    if !self.viewModel.output.tableData.value.isEmpty {
                        
                        vc.collectionView.selectItem(at: IndexPath(item: index, section:0), animated: true, scrollPosition: .centeredHorizontally)
                    }
                })
                .disposed(by: disposed)
            
            viewModel
                .output
                .currentPage
                .bind(to: pageControl.rx.currentPage)
                .disposed(by: disposed)
            
            var mutable: [FBCarouselBean] = []
            
            for _ in 0..<999 {
                
                mutable += result
            }
            
            viewModel
                .output
                .tableData
                .accept(mutable)
            
            vc
                .collectionView
                .rx
                .setDelegate(self)
                .disposed(by: disposed)
        }
    }
}
extension FBCarouselBridge: UICollectionViewDelegate {
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        DispatchQueue.main.async {
            
            let floatx = scrollView.contentOffset.x / WL_SCREEN_WIDTH
            
            let intx = floor(floatx)
            
            if floatx + 0.5 >= intx {
                
                self.vc.collectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / WL_SCREEN_WIDTH) + 1, section:0), animated: true, scrollPosition: .centeredHorizontally)
                
            } else if floatx - 0.5 <= intx {
                
                self.vc.collectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / WL_SCREEN_WIDTH) - 1, section:0), animated: true, scrollPosition: .centeredHorizontally)
            } else {
                
                self.vc.collectionView.selectItem(at: IndexPath(item: Int(scrollView.contentOffset.x / WL_SCREEN_WIDTH), section:0), animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
}
