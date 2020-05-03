//
//  ZNickameViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxCocoa
import FBViewModel
import FBResult
import FBRReq
import FBApi
import FBBean
import FBCache
import FBError
import FBObservableMapper

struct FBNameViewModel: FBViewModel {
    
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
        
        let completed: Driver<FBResult>
    }
    
    init(_ input: WLInput) {
        
        self.input = input
        
        let ou = Driver.combineLatest(input.orignal, input.updated)
        
        let completEnabled = ou.flatMapLatest { return Driver.just($0.0 != $0.1 && !$0.1.isEmpty && !$0.1.wl_isEmpty) }
        
        let completing: Driver<Void> = input.completTaps.flatMap { Driver.just($0) }
        
        let completed: Driver<FBResult> = input.completTaps
            .withLatestFrom(input.updated)
            .flatMapLatest({
                return FBDictResp(FBApi.updateUserInfo("users.nickname", value: $0))
                    .mapObject(type: FBUserBean.self)
                    .map({ FBUserInfoCache.default.saveUser(data: $0) })
                    .map { FBResult.updateUserInfoSucc($0, msg: "昵称修改成功")}
                    .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) }) })
        
        self.output = WLOutput(completeEnabled: completEnabled, completing: completing, completed: completed)
    }
}
