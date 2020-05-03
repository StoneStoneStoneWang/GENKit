//
//  Button+RX.swift
//  WLUserKitDemo
//
//  Created by three stone 王 on 2019/4/15.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    public var FBSkipTitle: Binder<String> {
        
        return Binder(self.base) {
            
            $0.setTitle($1, for: .normal)
            
            $0.setTitle($1, for: .highlighted)
        }
    }
}

extension Reactive where Base: UIButton {
    
    public var FBSms: Binder<(Bool ,String)> {
        return Binder(self.base) { item, arg in
            
            item.isEnabled = arg.0
            
            item.setTitle(arg.1, for: arg.0 ? .normal : .disabled)
        }
    }
}

