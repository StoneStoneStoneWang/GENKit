//
//  FBSignatureBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FBBase
import FBHud
import FBCache

@objc(FBSignatureActionType)
public enum FBSignatureActionType: Int ,Codable {
    
    case signature = 0
    
    case back = 1
}

public typealias FBSignatureAction = (_ action: FBSignatureActionType ) -> ()

@objc (FBSignatureBridge)
public final class FBSignatureBridge: FBBaseBridge {
    
    var viewModel: FBSignatureViewModel!
    
    let signature: BehaviorRelay<String> = BehaviorRelay<String>(value: FBUserInfoCache.default.userBean.signature)
}

extension FBSignatureBridge {
    
    @objc public func createSignature(_ vc: FBBaseViewController ,signatureAction: @escaping FBSignatureAction ) {
        
        if let completeItem = vc.navigationItem.rightBarButtonItem?.customView as? UIButton ,let signaturetv = vc.view.viewWithTag(201) as? UITextView ,let backItem = vc.navigationItem.leftBarButtonItem?.customView as? UIButton ,let placeholder = vc.view.viewWithTag(202) {
            
            let inputs = FBSignatureViewModel.WLInput(orignal: signature.asDriver(),
                                                       updated: signaturetv.rx.text.orEmpty.asDriver(),
                                                       completTaps: completeItem.rx.tap.asSignal())
            
            signaturetv.text = signature.value
            
            viewModel = FBSignatureViewModel(inputs)
            
            viewModel
                .output
                .completeEnabled
                .drive(completeItem.rx.isEnabled)
                .disposed(by: disposed)
            
            viewModel
                .output
                .completing
                .drive(onNext: { (_) in
                    
                    FBHud.show(withStatus: "修改个性签名...")
                    
                    signaturetv.resignFirstResponder()
                })
                .disposed(by: disposed)
            
            viewModel
                .output
                .completed
                .drive(onNext: { (result) in
                    
                    FBHud.pop()
                    
                    switch result {
                    case let .updateUserInfoSucc(_, msg: msg):
                        
                        FBHud.showInfo(msg)
                        
                        signatureAction(.signature)
                        
                    case let .failed(msg):
                        
                        FBHud.showInfo(msg)
                    default: break
                        
                    }
                })
                .disposed(by: disposed)
            
            backItem
                .rx
                .tap
                .subscribe(onNext: { (_) in
                    
                    signatureAction(.back)
                })
                .disposed(by: disposed)
            
            viewModel
                .output
                .placeholderHidden
                .drive(placeholder.rx.isHidden)
                .disposed(by: disposed)
        }
    }
}
