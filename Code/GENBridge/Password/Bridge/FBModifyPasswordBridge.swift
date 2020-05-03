//
//  FBModifyPwdBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBBase
import FBHud
import RxCocoa
import RxSwift
import FBCocoa

public typealias FBModifyPasswordAction = () -> ()

@objc (FBModifyPasswordBridge)
public final class FBModifyPasswordBridge: FBBaseBridge {
    
    public var viewModel: FBModifyPasswordViewModel!
}
// MARK:  旧密码201 新密码 202 确认密码 203 修改密码
extension FBModifyPasswordBridge {
    
    @objc public func createPassword(_ vc: FBBaseViewController ,passwordAction: @escaping FBModifyPasswordAction) {
        
        if let oldpassword = vc.view.viewWithTag(201) as? UITextField ,let password = vc.view.viewWithTag(202) as? UITextField ,let passwordAgain = vc.view.viewWithTag(203) as? UITextField ,let completeItem = vc.view.viewWithTag(204) as? UIButton {
            
            let input = FBModifyPasswordViewModel.WLInput(oldpassword: oldpassword.rx.text.orEmpty.asDriver(),
                                                           password: password.rx.text.orEmpty.asDriver() ,
                                                           passwordAgain: passwordAgain.rx.text.orEmpty.asDriver(),
                                                           completeTaps: completeItem.rx.tap.asSignal())
            
            viewModel = FBModifyPasswordViewModel(input, disposed: disposed)
            
            // MARK: 修改密码 点击
            viewModel
                .output
                .completing
                .drive(onNext: { _ in
                    
                    vc.view.endEditing(true)
                    
                    FBHud.show(withStatus: "修改密码中...")
                    
                })
                .disposed(by: disposed)
            
            // MARK: 修改密码 完成
            viewModel
                .output
                .completed
                .drive(onNext: {
                    
                    FBHud.pop()
                    
                    switch $0 {
                        
                    case let .failed(msg): FBHud.showInfo(msg)
                        
                    case let .ok(msg):
                        
                        FBHud.showInfo(msg)
                        
                        passwordAction()
                        
                    default: break
                    }
                })
                .disposed(by: disposed)
        }
    }
}
