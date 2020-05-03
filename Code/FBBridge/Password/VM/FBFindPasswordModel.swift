//
//  ZForgetPwdModel.swift
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
import FBCheck
import FBApi
import FBRReq

public struct FBFindPasswordModel: FBViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        /* 用户名 序列*/
        let username: Driver<String>
        /* 验证码 序列*/
        let vcode:Driver<String>
        /* 密码 序列*/
        let password:Driver<String>
        /* 验证码点击 序列*/
        let verifyTaps: Signal<Void>
        /* 定时器 序列*/
        let timer: Observable<Int> = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        
        let completeTaps: Signal<Void>
        
        let passwordItemSelected: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        
        let passwordItemTaps: Signal<Void>
    }
    
    public struct WLOutput {
        /* 获取验证码中 序列*/
        let verifying: Driver<Void>
        /* 获取验证码结果 序列*/
        let verifyed: Driver<FBResult>
        
        let completing: Driver<Void>
        
        let completed: Driver<FBResult>
        @available(*, deprecated, message: "Please use smsRelay")
        let sms: Variable<(Bool,String)> = Variable<(Bool,String)>((true,"获取验证码"))
        
        let smsRelay: BehaviorRelay<(Bool,String)> = BehaviorRelay<(Bool,String)>(value: (true,"获取验证码"))
        
        let passwordItemed: Driver<Bool>
        
        let passwordEntryed: Driver<Bool>
    }
    
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let uvp = Driver.combineLatest(input.username, input.vcode ,input.password)
        
        let verifying: Driver<Void> = input.verifyTaps.flatMap { Driver.just($0) }
        
        let duration: Int = 60
        
        let verifyed: Driver<FBResult> = input
            .verifyTaps
            .withLatestFrom(input.username)
            .flatMapLatest({ (username) in
                
                switch FBCheckUsername(username) {
                case .ok:
                    
                    let result: Observable<FBResult> = Observable<FBResult>.create({ (ob) -> Disposable in
 
                        FBVoidResp(FBApi.smsPassword(username))
                            .subscribe(onNext: { (_) in
                                
                                ob.onNext(FBResult.ok("验证码已发送到您的手机，请注意查收"))
                                
                                input.timer
                                    .map({ duration - $0 })
                                    .take(61)
                                    .map({ smsResult(count: $0) })
                                    .map({ FBResult.smsOk(isEnabled: $0, title: $1)})
                                    .subscribe(onNext: { (result) in
                                        
                                        ob.onNext(result)
                                    })
                                    .disposed(by: disposed)
                                
                            }, onError: { (error) in
                                
                                ob.onError(error)
                                
                            })
                            .disposed(by: disposed)
                        
                        return Disposables.create { }
                    })
                    
                    return result.asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
                    
                case let .failed(message: msg): return Driver<FBResult>.just(FBResult.failed( msg))
                    
                default: return Driver<FBResult>.empty()
                    
                }
            })
        
        let completing: Driver<Void> = input.completeTaps.flatMap { Driver.just($0) }
        
        let completed: Driver<FBResult> = input
            .completeTaps
            .withLatestFrom(uvp)
            .flatMapLatest {
                
                switch FBCheckPasswordForget($0.0, vcode: $0.1, password: $0.2) {
                case .ok:
                    
                    return FBVoidResp(FBApi.resettingPassword($0.0, password: $0.2, code: $0.1))
                        .map({ FBResult.ok("找回密码成功") })
                        .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
                    
                case let .failed(message: msg): return Driver<FBResult>.just(FBResult.failed( msg))
                default: return Driver<FBResult>.empty()
                    
                }
        }
        
        let passwordEntryed = input.passwordItemTaps.flatMapLatest { _ -> SharedSequence<DriverSharingStrategy, Bool> in return Driver.just(!input.passwordItemSelected.value) }
        
        let passwordItemed = input.passwordItemTaps.flatMapLatest { _ -> SharedSequence<DriverSharingStrategy, Bool> in
            
            input.passwordItemSelected.accept(!input.passwordItemSelected.value)
            
            return Driver.just(input.passwordItemSelected.value)
        }
        self.output = WLOutput(verifying: verifying, verifyed: verifyed, completing: completing, completed: completed, passwordItemed: passwordItemed, passwordEntryed: passwordEntryed)
    }
}

