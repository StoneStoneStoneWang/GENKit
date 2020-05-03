//
//  GENFeedBackViewModel.swift
//  GENBridge
//
//  Created by 王磊 on 2020/3/30.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import RxCocoa
import GENError
import GENViewModel
import WLToolsKit
import GENResult
import GENRReq
import GENApi

struct GENFeedBackViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let feedBack: Driver<String>
        
        let phone:Driver<String>
        
        let completTaps:Signal<Void>
    }
    
    struct WLOutput {
        
        let completeEnabled: Driver<Bool>
        
        let completing: Driver<Void>
        
        let completed: Driver<GENResult>
    }
    
    init(_ input: WLInput) {
        
        self.input = input
        
        let ou = Driver.combineLatest(input.feedBack, input.phone)
        
        let completEnabled = ou.flatMapLatest { return Driver.just($0.0 != $0.1 && !$0.1.isEmpty && !$0.1.wl_isEmpty) }
        
        let completing: Driver<Void> = input.completTaps.flatMap { Driver.just($0) }
        
        let completed: Driver<GENResult> = input.completTaps
            .withLatestFrom(ou)
            .flatMapLatest({
                
                return GENVoidResp(GENApi.feedback("yuanxingfu1314@163.com", content: $0.0))
                    .map { _ in GENResult.ok("意见建议提交成功")}
                    .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) }) })
        
        self.output = WLOutput(completeEnabled: completEnabled, completing: completing, completed: completed)
    }
}
