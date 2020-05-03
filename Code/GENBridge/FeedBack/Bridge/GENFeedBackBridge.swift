//
//  GENFeedBackBridge.swift
//  GENBridge
//
//  Created by 王磊 on 2020/3/30.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import GENBase
import GENHud
import GENTextView

public typealias GENFeedBackAction = () -> ()

@objc (GENFeedBackBridge)
public final class GENFeedBackBridge: GENBaseBridge {
    
    var viewModel: GENFeedBackViewModel!
}

extension GENFeedBackBridge {
    
    @objc public func createFeedBack(_ vc: GENBaseViewController ,textView: GENTextView,feedBackAction: @escaping GENFeedBackAction ) {
        
        if let phone = vc.view.viewWithTag(203) as? UITextField {
            
            var completeItem: UIButton!
            
            if let complete = vc.navigationItem.rightBarButtonItem?.customView as? UIButton  {
                
                completeItem = complete
            }
            if let complete = vc.view.viewWithTag(204) as? UIButton {
                
                completeItem = complete
            }
            
            if let completeItem = completeItem {
                
                let inputs = GENFeedBackViewModel.WLInput(feedBack: textView.textView.rx.text.orEmpty.asDriver(),
                                                          phone: phone.rx.text.orEmpty.asDriver(),
                                                          completTaps: completeItem.rx.tap.asSignal())
                
                viewModel = GENFeedBackViewModel(inputs)
                
                viewModel
                    .output
                    .completeEnabled
                    .drive(completeItem.rx.isEnabled)
                    .disposed(by: disposed)
                
                viewModel
                    .output
                    .completing
                    .drive(onNext: { (_) in
                        
                        GENHud.show(withStatus: "意见建议提交中...")
                        
                        vc.view.endEditing(true)
                    })
                    .disposed(by: disposed)
                
                viewModel
                    .output
                    .completed
                    .drive(onNext: { (result) in
                        
                        GENHud.pop()
                        
                        switch result {
                        case let .ok(msg):
                            
                            GENHud.showInfo(msg)
                            
                            feedBackAction()
                            
                        case let .failed(msg):
                            
                            GENHud.showInfo(msg)
                        default: break
                            
                        }
                    })
                    .disposed(by: disposed)
                
            }
        }
    }
    
}
