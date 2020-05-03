//
//  FBNameBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBBase
import FBHud
import FBBean
import RxCocoa
import FBCache
import RxSwift

@objc(FBNameActionType)
public enum FBNameActionType: Int ,Codable {
    
    case name = 0
    
    case back = 1
}

public typealias FBNameAction = (_ action: FBNameActionType ) -> ()

@objc (FBNameBridge)
public final class FBNameBridge: FBBaseBridge {
    
    var viewModel: FBNameViewModel!
    
    let nickname: BehaviorRelay<String> = BehaviorRelay<String>(value: FBUserInfoCache.default.userBean.nickname)
}

extension FBNameBridge {
    
    @objc public func createName(_ vc: FBBaseViewController ,nameAction: @escaping FBNameAction ) {
        
        if let completeItem = vc.navigationItem.rightBarButtonItem?.customView as? UIButton ,let name = vc.view.viewWithTag(201) as? UITextField ,let backItem = vc.navigationItem.leftBarButtonItem?.customView as? UIButton{
            
            let inputs = FBNameViewModel.WLInput(orignal: nickname.asDriver(),
                                                       updated: name.rx.text.orEmpty.asDriver(),
                                                       completTaps: completeItem.rx.tap.asSignal())
            
            name.text = nickname.value
            
            viewModel = FBNameViewModel(inputs)
            
            viewModel
                .output
                .completeEnabled
                .drive(completeItem.rx.isEnabled)
                .disposed(by: disposed)
            
            viewModel
                .output
                .completing
                .drive(onNext: { (_) in
                    
                    name.resignFirstResponder()
                    
                    FBHud.show(withStatus: "修改昵称中...")
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
                        
                        nameAction(.name)
                        
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
                    
                    nameAction(.back)
                })
                .disposed(by: disposed)
        }
    }
}
