//
//  FBBlackViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import FBResult
import FBRReq
import FBBean
import FBApi
import FBError
import FBObservableMapper

public struct FBBlackViewModel: FBViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        
        let modelSelect: ControlEvent<FBBlackBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
    }
    
    public struct WLOutput {
        
        let zip: Observable<(FBBlackBean,IndexPath)>
        
        let tableData: BehaviorRelay<[FBBlackBean]> = BehaviorRelay<[FBBlackBean]>(value: [])
        
        let endHeaderRefreshing: Driver<FBResult>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .startWith(())
            .flatMapLatest({_ in

                return FBArrayResp(FBApi.fetchBlackList)
                    .mapArray(type: FBBlackBean.self)
                    .map({ return $0.count > 0 ? FBResult.fetchList($0) : FBResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
            })
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let output = WLOutput(zip: zip, endHeaderRefreshing: endHeaderRefreshing)
        
        headerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    output.tableData.accept(items as! [FBBlackBean])
                    
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
}
extension FBBlackViewModel {
    
    static func removeBlack(_ encode: String) -> Driver<FBResult> {
        
        return FBVoidResp(FBApi.removeBlack(encode))
            .flatMapLatest({ return Driver.just(FBResult.ok("移除成功")) })
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
}
