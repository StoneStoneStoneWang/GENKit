//
//  GENVideoViewModel.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/22.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENViewModel
import RxCocoa
import RxSwift
import GENResult
import GENRReq
import GENApi
import GENError

struct GENVideoViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
    }
    
    struct WLOutput {
    
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        self.output = WLOutput()
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
}
