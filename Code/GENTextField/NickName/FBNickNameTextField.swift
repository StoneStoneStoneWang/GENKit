//
//  WLNickNameTextFiled.swift
//  WLCompoentViewDemo
//
//  Created by three stone 王 on 2019/4/16.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import UIKit

@objc (FBNickNameTextField)
public final class FBNickNameTextField: FBBaseTextField {
    @objc (margin)
    public var margin: CGFloat = 15
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.editingRect(forBounds: bounds)
        
        return CGRect(x: rect.minX + margin, y: rect.minY, width: rect.width - margin, height: rect.height)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.textRect(forBounds: bounds)
        
        return CGRect(x: rect.minX + margin, y: rect.minY, width: rect.width - margin, height: rect.height)
    }
    @objc (commitInit)
    public override func commitInit() {
        super.commitInit()
        
        FB_editType(.default)
    }
}
