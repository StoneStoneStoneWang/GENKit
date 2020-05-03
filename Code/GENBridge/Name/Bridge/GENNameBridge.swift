//
//  GENNameBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENBase
import GENHud
import GENBean
import RxCocoa
import GENCache
import RxSwift

@objc(GENNameActionType)
public enum GENNameActionType: Int ,Codable {
    
    case name = 0
    
    case back = 1
}

public typealias GENNameAction = (_ action: GENNameActionType ) -> ()

@objc (GENNameBridge)
public final class GENNameBridge: GENBaseBridge {
    
    var viewModel: GENNameViewModel!
    
    let nickname: BehaviorRelay<String> = BehaviorRelay<String>(value: GENUserInfoCache.default.userBean.nickname)
}

extension GENNameBridge {
    
    @objc public func createName(_ vc: GENBaseViewController ,nameAction: @escaping GENNameAction ) {
        
        if let completeItem = vc.navigationItem.rightBarButtonItem?.customView as? UIButton ,let name = vc.view.viewWithTag(201) as? UITextField ,let backItem = vc.navigationItem.leftBarButtonItem?.customView as? UIButton{
            
            let inputs = GENNameViewModel.WLInput(orignal: nickname.asDriver(),
                                                       updated: name.rx.text.orEmpty.asDriver(),
                                                       completTaps: completeItem.rx.tap.asSignal())
            
            name.text = nickname.value
            
            viewModel = GENNameViewModel(inputs)
            
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
                    
                    GENHud.show(withStatus: "修改昵称中...")
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
                        
                        nameAction(.name)
                        
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
                    
                    nameAction(.back)
                })
                .disposed(by: disposed)
        }
    }
}
