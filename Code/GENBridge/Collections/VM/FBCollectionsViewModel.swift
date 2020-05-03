//
//  FBCollectionsViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/29.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import FBResult
import FBBean
import FBRReq
import FBApi
import FBError

public struct FBCollectionsViewModel: FBViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        
        let isMy: Bool
        
        let modelSelect: ControlEvent<FBCircleBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
        
        let footerRefresh: Driver<Void>
        
        let page: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
        
        let tag: String
    }
    
    public struct WLOutput {
        
        let zip: Observable<(FBCircleBean,IndexPath)>
        
        public let collectionData: BehaviorRelay<[FBCircleBean]> = BehaviorRelay<[FBCircleBean]>(value: [])
        
        let endHeaderRefreshing: Driver<FBResult>
        
        let endFooterRefreshing: Driver<FBResult>
        
        let footerHidden: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .flatMapLatest({_ in
                
                return FBArrayResp(input.isMy ? FBApi.fetchMyList(input.tag, page: 1) : FBApi.fetchList(input.tag, page: 1))
                    .mapArray(type: FBCircleBean.self)
                    .map({ return $0.count > 0 ? FBResult.fetchList($0) : FBResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
            })
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let footerRefreshData = input
            .footerRefresh
            .flatMapLatest({_ in
                
                return FBArrayResp(input.isMy ? FBApi.fetchMyList(input.tag, page: input.page.value) : FBApi.fetchList(input.tag, page: input.page.value))
                    .mapArray(type: FBCircleBean.self)
                    .map({ return $0.count > 0 ? FBResult.fetchList($0) : FBResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
            })
        
        let endFooterRefreshing = footerRefreshData.map { $0 }
        
        let output = WLOutput(zip: zip, endHeaderRefreshing: endHeaderRefreshing, endFooterRefreshing: endFooterRefreshing)
        
        headerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    if !items.isEmpty {
                        
                        input.page.accept(2)
                        
                        if items.count < 20 {
                            
                            output.footerHidden.accept(true)
                            
                            input.page.accept(1)
                        } else {
                            
                            output.footerHidden.accept(false)
                        }
                    } else {
                        
                        input.page.accept(1)
                        
                        output.footerHidden.accept(true)
                    }
                    
                    output.collectionData.accept(items as! [FBCircleBean])
                    
                case .empty: output.collectionData.accept([])
                default: break
                }
            })
            .disposed(by: disposed)
        
        footerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    if !items.isEmpty {
                        
                        var page = input.page.value
                        
                        page += 1
                        
                        input.page.accept(page)
                        
                        if items.count < 20 {
                            
                            output.footerHidden.accept(true)
                            
                        } else {
                            
                            output.footerHidden.accept(false)
                        }
                    } else {
                        
                        output.footerHidden.accept(true)
                    }
                    
                    var values = output.collectionData.value
                    
                    values += items as! [FBCircleBean]
                    
                    output.collectionData.accept(values )
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
    
    static func addBlack(_ OUsEncoded: String,targetEncoded: String ,content: String) -> Driver<FBResult> {
        
        return FBVoidResp(FBApi.addBlack(OUsEncoded, targetEncoded: targetEncoded, content: content))
            .map({ _ in FBResult.ok("添加黑名单成功")})
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
    static func focus(_ uid: String ,encode: String) -> Driver<FBResult> {
        
        return FBVoidResp(FBApi.focus(uid, targetEncoded: encode))
            .flatMapLatest({ return Driver.just(FBResult.ok("关注或取消关注成功")) })
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
    
    static func like(_ encoded: String ,isLike: Bool) -> Driver<FBResult> {
        
        return FBVoidResp(FBApi.like(encoded))
            .flatMapLatest({ return Driver.just(FBResult.ok( isLike ? "点赞成功" : "取消点赞成功")) })
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
    static func removeMyCircle(_ encoded: String ) -> Driver<FBResult> {
        
        return FBVoidResp(FBApi.deleteMyCircle(encoded))
            .map({ FBResult.ok("删除成功！")  })
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
}
