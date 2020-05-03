//
//  GENSignatureViewModel.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxCocoa
import GENViewModel
import WLToolsKit
import GENResult
import GENRReq
import GENApi
import GENBean
import GENCache
import GENError
import GENObservableMapper

struct GENSignatureViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let orignal: Driver<String>
        
        let updated:Driver<String>
        
        let completTaps:Signal<Void>
    }
    
    struct WLOutput {
        
        let completeEnabled: Driver<Bool>
        
        let completing: Driver<Void>
        
        let completed: Driver<GENResult>
        
        let placeholderHidden: Driver<Bool>
    }
    
    init(_ input: WLInput) {
        
        self.input = input
        
        let ou = Driver.combineLatest(input.orignal, input.updated)
        
        let completEnabled = ou.flatMapLatest { return Driver.just($0.0 != $0.1 && !$0.1.isEmpty && !$0.1.wl_isEmpty) }
        
        let completing: Driver<Void> = input.completTaps.flatMap { Driver.just($0) }
        
        let completed: Driver<GENResult> = input.completTaps
            .withLatestFrom(input.updated)
            .flatMapLatest({ return GENDictResp(GENApi.updateUserInfo("users.signature", value: $0))
                .mapObject(type: GENUserBean.self)
                .map({ GENUserInfoCache.default.saveUser(data: $0) })
                .map { GENResult.updateUserInfoSucc($0, msg: "个性签名修改成功")}
                .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) }) })
        
        let placeholderHidden: Driver<Bool> = input.updated.flatMapLatest { Driver.just(!$0.wl_isEmpty)}
        
        self.output = WLOutput(completeEnabled: completEnabled, completing: completing, completed: completed, placeholderHidden: placeholderHidden)
    }
}
