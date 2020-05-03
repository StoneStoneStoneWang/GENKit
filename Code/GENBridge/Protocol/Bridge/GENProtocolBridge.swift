//
//  GENProtocolBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/25.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENInner

@objc (GENProtocolBridge)
public final class GENProtocolBridge: GENBaseBridge {
    
    public var viewModel: GENProtocolViewModel!
}

extension GENProtocolBridge {
    
    @objc public func createProtocol(_ vc: GENInnerViewController) {
        
        let inputs = GENProtocolViewModel.WLInput()
        
        viewModel = GENProtocolViewModel(inputs)
        
        viewModel
            .output
            .contented
            .asObservable()
            .subscribe(onNext: {(value) in
                
                DispatchQueue.main.async {
                    
                    vc.GENLoadHtmlString(htmlString: value)
                }
                
            })
            .disposed(by: disposed)
    }
}
