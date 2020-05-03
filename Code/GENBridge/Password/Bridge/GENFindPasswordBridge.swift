//
//  GENFindPwdBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENBase
import GENHud
import RxCocoa
import RxSwift
import GENCocoa

public typealias GENFindPasswordAction = () -> ()

@objc (GENFindPasswordBridge)
public final class GENFindPasswordBridge: GENBaseBridge {
    
    public var viewModel: GENFindPasswordModel!
}
// MARK:  手机号 201  验证码 202  密码 203  完成按钮 204
extension GENFindPasswordBridge {
    
    @objc public func createPassword(_ vc: GENBaseViewController,passwordAction: @escaping GENFindPasswordAction ) {
        
        if let phone = vc.view.viewWithTag(201) as? UITextField ,let vcode = vc.view.viewWithTag(202) as? UITextField ,let vcodeItem = vcode.rightView as? UIButton,let password = vc.view.viewWithTag(203) as? UITextField, let passwordItem = password.rightView
            as? UIButton ,let completeItem = vc.view.viewWithTag(204) as? UIButton {
            
            let input = GENFindPasswordModel.WLInput(username: phone.rx.text.orEmpty.asDriver(),
                                              vcode: vcode.rx.text.orEmpty.asDriver() ,
                                              password: password.rx.text.orEmpty.asDriver(),
                                              verifyTaps: vcodeItem.rx.tap.asSignal(),
                                              completeTaps: completeItem.rx.tap.asSignal(),
                                              passwordItemTaps: passwordItem.rx.tap.asSignal())
            
            viewModel = GENFindPasswordModel(input, disposed: disposed)
            
            // MARK: 完成点击中序列
            viewModel
                .output
                .completing
                .drive(onNext: { _ in
                    
                    vc.view.endEditing(true)
                    
                    GENHud.show(withStatus: "找回密码中...")
                    
                })
                .disposed(by: disposed)
            
            // MARK: 完成事件返回序列
            viewModel
                .output
                .completed
                .drive(onNext: {
                    
                    GENHud.pop()
                    
                    switch $0 {
                        
                    case let .failed(msg): GENHud.showInfo(msg)
                        
                    case let .ok(msg):
                        
                        GENHud.showInfo(msg)
                        
                        passwordAction()
                        
                    default: break
                    }
                })
                .disposed(by: disposed)
            // 验证码序列
            viewModel
                .output
                .verifying
                .drive(onNext: { (_) in
                    
                    vc.view.endEditing(true)
                    
                    GENHud.show(withStatus: "获取验证码中...")
                })
                .disposed(by: disposed)
            // 验证码结果序列
            viewModel
                .output
                .smsRelay
                .asObservable()
                .bind(to: vcodeItem.rx.GENSms)
                .disposed(by: disposed)
            // 验证码结果序列
            viewModel
                .output
                .verifyed
                .drive(onNext: { [weak self] result in
                    
                    guard let `self` = self else { return }
                    
                    switch result {
                    case let .failed(message: msg):
                        GENHud.pop()
                        GENHud.showInfo(msg)
                    case let .ok(msg):
                        GENHud.pop()
                        GENHud.showInfo(msg)
                    case let .smsOk(isEnabled: isEnabled, title: title):
                        
                        self.viewModel.output.smsRelay.accept((isEnabled,title))
                    default: break
                        
                    }
                })
                .disposed(by: disposed)
            
            viewModel
                .output
                .passwordItemed
                .drive(passwordItem.rx.isSelected)
                .disposed(by: disposed)
            
            viewModel
                .output
                .passwordEntryed
                .drive(password.rx.isSecureTextEntry)
                .disposed(by: disposed)
        }
    }
}
