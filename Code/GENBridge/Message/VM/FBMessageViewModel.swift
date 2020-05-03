//
//  FBMessageViewModel.swift
//  FBBridge
//
//  Created by 王磊 on 2020/4/13.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import FBResult
import FBApi
import FBBean
import FBRReq
import FBError
import FBObservableMapper

struct FBMessageViewModel: FBViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<FBMessageBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
        
    }
    
    struct WLOutput {
        
        let zip: Observable<(FBMessageBean,IndexPath)>
        
        let collectionData: BehaviorRelay<[FBMessageBean]> = BehaviorRelay<[FBMessageBean]>(value: [])
        
        let endHeaderRefreshing: Driver<FBResult>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .startWith(())
            .flatMapLatest({_ in
                return FBArrayResp(FBApi.fetchSystemMsg(1))
                    .mapArray(type: FBMessageBean.self)
                    .map({ return $0.count > 0 ? FBResult.fetchList($0) : FBResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
            })
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let output = WLOutput(zip: zip, endHeaderRefreshing: endHeaderRefreshing)
        
        headerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    output.collectionData.accept(items as! [FBMessageBean])
                    
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
}
extension FBMessageViewModel {
    
    static func messageRead(_ encode: String) -> Driver<FBResult> {
        
        return FBVoidResp(FBApi.readMsg(encode))
            .flatMapLatest({ return Driver.just(FBResult.ok("")) })
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
    
    static func fetchFirstMessage() -> Driver<FBResult> {
        
        return FBArrayResp(FBApi.fetchFirstMsg)
            .mapArray(type: FBMessageBean.self)
            .flatMapLatest({ return Driver.just(FBResult.fetchList($0)) })
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
}
