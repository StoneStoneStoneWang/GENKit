//
//  GENAddressViewModel.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/20.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENViewModel
import RxCocoa
import RxSwift
import GENResult
import GENApi
import GENBean
import GENRReq
import GENObservableMapper
import GENError


struct GENAddressViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<GENAddressBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
        
        let itemAccessoryButtonTapped: Driver<IndexPath>
        
        let addItemTaps: Signal<Void>
    }
    
    struct WLOutput {
        
        let zip: Observable<(GENAddressBean,IndexPath)>
        
        let tableData: BehaviorRelay<[GENAddressBean]> = BehaviorRelay<[GENAddressBean]>(value: [])
        
        let endHeaderRefreshing: Driver<GENResult>
        
        let addItemed: Driver<Void>
        
        let itemAccessoryButtonTapped: Driver<IndexPath>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .startWith(())
            .flatMapLatest({_ in
                return GENArrayResp(GENApi.fetchAddress)
                    .mapArray(type: GENAddressBean.self)
                    .map({ return $0.count > 0 ? GENResult.fetchList($0) : GENResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
            })
        
        let itemAccessoryButtonTapped: Driver<IndexPath> = input.itemAccessoryButtonTapped.map { $0 }
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let addItemed: Driver<Void> = input.addItemTaps.flatMap { Driver.just($0) }
        
        let output = WLOutput(zip: zip, endHeaderRefreshing: endHeaderRefreshing, addItemed: addItemed, itemAccessoryButtonTapped: itemAccessoryButtonTapped)
        
        headerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    output.tableData.accept(items as! [GENAddressBean])
                    
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
}
extension GENAddressViewModel {
    
    static func removeAddress(_ encode: String) -> Driver<GENResult> {
        
        return GENVoidResp(GENApi.deleteAddress(encode))
            .flatMapLatest({ return Driver.just(GENResult.ok("移除成功")) })
            .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
    }
}
