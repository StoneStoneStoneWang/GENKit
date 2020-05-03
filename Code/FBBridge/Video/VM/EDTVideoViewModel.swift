//
//  FBVideoViewModel.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/22.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import FBResult
import FBRReq
import FBApi
import FBError

struct FBVideoViewModel: FBViewModel {
    
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
}
