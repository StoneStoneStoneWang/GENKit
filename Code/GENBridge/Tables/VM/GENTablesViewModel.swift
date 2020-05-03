//
//  GENTablesViewModel.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/29.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENViewModel
import RxCocoa
import RxSwift
import GENResult
import GENBean
import GENRReq
import GENApi
import GENObservableMapper
import GENError

struct GENTablesViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let isMy: Bool
        
        let modelSelect: ControlEvent<GENCircleBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
        
        let footerRefresh: Driver<Void>
        
        let page: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
        
        let tag: String
    }
    
    struct WLOutput {
        
        let zip: Observable<(GENCircleBean,IndexPath)>
        
        let tableData: BehaviorRelay<[GENCircleBean]> = BehaviorRelay<[GENCircleBean]>(value: [])
        
        let endHeaderRefreshing: Driver<GENResult>
        
        let endFooterRefreshing: Driver<GENResult>
        
        let footerHidden: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .flatMapLatest({_ in
                
                return GENArrayResp(input.isMy ? GENApi.fetchMyList(input.tag, page: 1) : GENApi.fetchList(input.tag, page: 1))
                    .mapArray(type: GENCircleBean.self)
                    .map({ return $0.count > 0 ? GENResult.fetchList($0) : GENResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
            })
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let footerRefreshData = input
            .footerRefresh
            .flatMapLatest({_ in
                
                return GENArrayResp(input.isMy ? GENApi.fetchMyList(input.tag, page: input.page.value) : GENApi.fetchList(input.tag, page: input.page.value))
                    .mapArray(type: GENCircleBean.self)
                    .map({ return $0.count > 0 ? GENResult.fetchList($0) : GENResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
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
                    
                    output.tableData.accept(items as! [GENCircleBean])
                    
                case .empty: output.tableData.accept([])
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
                    
                    var values = output.tableData.value
                    
                    values += items as! [GENCircleBean]
                    
                    output.tableData.accept(values )
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
    
    static func addBlack(_ OUsEncoded: String,targetEncoded: String ,content: String) -> Driver<GENResult> {
       
        return GENVoidResp(GENApi.addBlack(OUsEncoded, targetEncoded: targetEncoded, content: content))
            .map({ _ in GENResult.ok("添加黑名单成功")})
            .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
    }
    static func focus(_ uid: String ,encode: String) -> Driver<GENResult> {
        
        return GENVoidResp(GENApi.focus(uid, targetEncoded: encode))
            .flatMapLatest({ return Driver.just(GENResult.ok("关注或取消关注成功")) })
            .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
    }
    
    static func like(_ encoded: String ,isLike: Bool) -> Driver<GENResult> {
        
        return GENVoidResp(GENApi.like(encoded))
            .flatMapLatest({ return Driver.just(GENResult.ok( isLike ? "点赞成功" : "取消点赞成功")) })
            .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
    }
    static func removeMyCircle(_ encoded: String ) -> Driver<GENResult> {
        
        return GENVoidResp(GENApi.deleteMyCircle(encoded))
            .map({ GENResult.ok("删除成功！")  })
            .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
    }
}
