//
//  FBLeftTitleTextField.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/22.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import WLToolsKit

@objc (FBLeftTitleTextField)
open class FBLeftTitleTextField: FBBaseTextField {
    
    open var leftTitleLabel: UILabel = UILabel()
    @objc (leftTitle)
    open var leftTitle: String = "" {
        
        willSet {
            
            guard !newValue.isEmpty else { return }
            
            leftViewMode = .always
            
            leftTitleLabel.textAlignment = .center
            
            leftTitleLabel.textColor = WLHEXCOLOR(hexColor: "#666666")
            
            leftTitleLabel.font = UIFont.systemFont(ofSize: 15)
            
            leftView = leftTitleLabel
            
            leftTitleLabel.text = newValue
        }
    }
    @objc (leftTitleFrame)
    open var leftTitleFrame: CGRect = .zero {
        
        willSet {
            
            leftTitleLabel.frame = newValue
        }
    }
    @objc (commitInit)
    open override func commitInit() {
        super.commitInit()
        
        leftTitleFrame = CGRect(x: 0, y: 0, width: 80, height: 44)
    }
    
}

extension FBLeftTitleTextField {
    
    @objc open override func makeAttribute(_ closure: @escaping (FBLeftTitleTextField) -> ()) {
        
        closure(self)
    }
}
