//
//  GENMessageViewModel.swift
//  GENBridge
//
//  Created by 王磊 on 2020/4/13.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import GENViewModel
import RxCocoa
import RxSwift
import GENResult
import GENApi
import GENBean
import GENRReq
import GENError
import GENObservableMapper

struct GENMessageViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<GENMessageBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
        
    }
    
    struct WLOutput {
        
        let zip: Observable<(GENMessageBean,IndexPath)>
        
        let collectionData: BehaviorRelay<[GENMessageBean]> = BehaviorRelay<[GENMessageBean]>(value: [])
        
        let endHeaderRefreshing: Driver<GENResult>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .startWith(())
            .flatMapLatest({_ in
                return GENArrayResp(GENApi.fetchSystemMsg(1))
                    .mapArray(type: GENMessageBean.self)
                    .map({ return $0.count > 0 ? GENResult.fetchList($0) : GENResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
            })
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let output = WLOutput(zip: zip, endHeaderRefreshing: endHeaderRefreshing)
        
        headerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    output.collectionData.accept(items as! [GENMessageBean])
                    
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
}
extension GENMessageViewModel {
    
    static func messageRead(_ encode: String) -> Driver<GENResult> {
        
        return GENVoidResp(GENApi.readMsg(encode))
            .flatMapLatest({ return Driver.just(GENResult.ok("")) })
            .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
    }
    
    static func fetchFirstMessage() -> Driver<GENResult> {
        
        return GENArrayResp(GENApi.fetchFirstMsg)
            .mapArray(type: GENMessageBean.self)
            .flatMapLatest({ return Driver.just(GENResult.fetchList($0)) })
            .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
    }
}
