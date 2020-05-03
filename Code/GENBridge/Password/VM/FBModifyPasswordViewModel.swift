//
//  ZModifyPwdViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import FBObservableMapper
import FBError
import FBResult
import FBApi
import FBRReq
import FBCheck

public struct FBModifyPasswordViewModel: FBViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        /* 旧密码 序列*/
        let oldpassword: Driver<String>
        /* 新密码 序列*/
        let password:Driver<String>
        /* 重复新密码 序列*/
        let passwordAgain:Driver<String>
        
        let completeTaps: Signal<Void>
    }
    
    public struct WLOutput {
        
        let completing: Driver<Void>
        
        let completed: Driver<FBResult>
    }
    
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let opa = Driver.combineLatest(input.oldpassword, input.password ,input.passwordAgain)
        
        let completing: Driver<Void> = input.completeTaps.flatMap { Driver.just($0) }
        
        let completed: Driver<FBResult> = input
            .completeTaps
            .withLatestFrom(opa)
            .flatMapLatest {
                
                switch FBCheckPasswordModify($0.0, password: $0.2, passwordAgain: $0.1) {
                case .ok: return FBVoidResp(FBApi.modifyPassword($0.0, password: $0.1))
                    .map({ FBResult.ok("修改密码成功") })
                    .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
                    
                case let .failed(message: msg): return Driver<FBResult>.just(FBResult.failed( msg))
                default: return Driver<FBResult>.empty()
                    
                }
        }
        
        self.output = WLOutput( completing: completing, completed: completed)
    }
}

