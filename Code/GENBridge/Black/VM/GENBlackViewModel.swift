//
//  GENBlackViewModel.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENViewModel
import RxCocoa
import RxSwift
import GENResult
import GENRReq
import GENBean
import GENApi
import GENError
import GENObservableMapper

public struct GENBlackViewModel: GENViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        
        let modelSelect: ControlEvent<GENBlackBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
    }
    
    public struct WLOutput {
        
        let zip: Observable<(GENBlackBean,IndexPath)>
        
        let tableData: BehaviorRelay<[GENBlackBean]> = BehaviorRelay<[GENBlackBean]>(value: [])
        
        let endHeaderRefreshing: Driver<GENResult>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .startWith(())
            .flatMapLatest({_ in

                return GENArrayResp(GENApi.fetchBlackList)
                    .mapArray(type: GENBlackBean.self)
                    .map({ return $0.count > 0 ? GENResult.fetchList($0) : GENResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
            })
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let output = WLOutput(zip: zip, endHeaderRefreshing: endHeaderRefreshing)
        
        headerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    output.tableData.accept(items as! [GENBlackBean])
                    
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
}
extension GENBlackViewModel {
    
    static func removeBlack(_ encode: String) -> Driver<GENResult> {
        
        return GENVoidResp(GENApi.removeBlack(encode))
            .flatMapLatest({ return Driver.just(GENResult.ok("移除成功")) })
            .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
    }
}
