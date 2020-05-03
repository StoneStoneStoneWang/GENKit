//
//  GENSignatureBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import GENBase
import GENHud
import GENCache
import GENTextView

@objc(GENSignatureActionType)
public enum GENSignatureActionType: Int ,Codable {
    
    case signature = 0
    
    case back = 1
}

public typealias GENSignatureAction = (_ action: GENSignatureActionType ) -> ()

@objc (GENSignatureBridge)
public final class GENSignatureBridge: GENBaseBridge {
    
    var viewModel: GENSignatureViewModel!
    
    let signature: BehaviorRelay<String> = BehaviorRelay<String>(value: GENUserInfoCache.default.userBean.signature)
}

extension GENSignatureBridge {
    
    @objc public func createSignature(_ vc: GENBaseViewController ,textView: GENTextView,signatureAction: @escaping GENSignatureAction ) {
        
        if let completeItem = vc.navigationItem.rightBarButtonItem?.customView as? UIButton,let backItem = vc.navigationItem.leftBarButtonItem?.customView as? UIButton {
            
            let inputs = GENSignatureViewModel.WLInput(orignal: signature.asDriver(),
                                                       updated: textView.textView.rx.text.orEmpty.asDriver(),
                                                       completTaps: completeItem.rx.tap.asSignal())
            
            textView.textView.text = signature.value
            
            viewModel = GENSignatureViewModel(inputs)
            
            viewModel
                .output
                .completeEnabled
                .drive(completeItem.rx.isEnabled)
                .disposed(by: disposed)
            
            viewModel
                .output
                .completing
                .drive(onNext: { (_) in
                    
                    GENHud.show(withStatus: "修改个性签名...")
                    
                    vc.view.endEditing(true)
                })
                .disposed(by: disposed)
            
            viewModel
                .output
                .completed
                .drive(onNext: { (result) in
                    
                    GENHud.pop()
                    
                    switch result {
                    case let .updateUserInfoSucc(_, msg: msg):
                        
                        GENHud.showInfo(msg)
                        
                        signatureAction(.signature)
                        
                    case let .failed(msg):
                        
                        GENHud.showInfo(msg)
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
        }
    }
}
