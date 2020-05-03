//
//  FBProtocolBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/25.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBTextInner

@objc (FBProtocolBridge)
public final class FBProtocolBridge: FBBaseBridge {
    
    public var viewModel: FBProtocolViewModel!
}

extension FBProtocolBridge {
    
    @objc public func createProtocol(_ vc: FBTextInnerViewController) {
        
        let inputs = FBProtocolViewModel.WLInput()
        
        viewModel = FBProtocolViewModel(inputs)
        
        viewModel
            .output
            .contented
            .asObservable()
            .subscribe(onNext: {(value) in
                
                DispatchQueue.main.async {
                    
                    vc.FBLoadHtmlString(htmlString: value)
                }
                
            })
            .disposed(by: disposed)
    }
}
