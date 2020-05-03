//
//  WLPasswordTextFiled.swift
//  WLCompoentViewDemo
//
//  Created by three stone 王 on 2019/4/16.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import UIKit

@objc (FBPasswordImageTextFiled)
public final class FBPasswordImageTextFiled: FBLeftImageTextField {
    
    @objc (passwordItem)
    public final let passwordItem: UIButton = UIButton(type: .custom)
    @objc (normalIcon)
    public  var normalIcon: String = "" {
        
        willSet {
            guard !newValue.isEmpty else { return }
            passwordItem.setImage(UIImage(named: newValue), for: .normal)
            passwordItem.setImage(UIImage(named: newValue), for: .highlighted)
            rightView = passwordItem
        }
    }
    @objc (selectedIcon)
    public var selectedIcon: String = "" {
        
        willSet {
            guard !newValue.isEmpty else { return }
            passwordItem.setImage(UIImage(named: newValue), for: .selected)
        }
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.rightViewRect(forBounds: bounds)
        
        return CGRect(x: rect.minX - 30, y: rect.minY, width: rect.width , height: rect.height)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.editingRect(forBounds: bounds)
        
        return CGRect(x: rect.minX, y: rect.minY, width: rect.width  - 30, height: rect.height)
    }
    
    @objc (commitInit)
    public override func commitInit() {
        super.commitInit()
        
        FB_rightViewMode(.always)
    
        FB_editType(.secret)
        
        FB_maxLength(18)
        
        FB_secureTextEntry(true)
        
    }
}

@objc (FBPasswordTitleTextFiled)
public final class FBPasswordTitleTextFiled: FBLeftTitleTextField {
    
    @objc (passwordItem)
    public final let passwordItem: UIButton = UIButton(type: .custom)
    
    @objc (normalIcon)
    public  var normalIcon: String = "" {
        
        willSet {
            guard !newValue.isEmpty else { return }
            passwordItem.setImage(UIImage(named: newValue), for: .normal)
            passwordItem.setImage(UIImage(named: newValue), for: .highlighted)
        }
    }
    @objc (selectedIcon)
    public var selectedIcon: String = "" {
        
        willSet {
            guard !newValue.isEmpty else { return }
            passwordItem.setImage(UIImage(named: newValue), for: .selected)
        }
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.rightViewRect(forBounds: bounds)
        
        return CGRect(x: rect.minX - 30, y: rect.minY, width: rect.width , height: rect.height)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.editingRect(forBounds: bounds)
        
        return CGRect(x: rect.minX, y: rect.minY, width: rect.width  - 30, height: rect.height)
    }
    @objc (commitInit)
    public override func commitInit() {
        super.commitInit()
        
        FB_rightViewMode(.always)
        
        FB_rightView(passwordItem)
        
        FB_editType(.secret)
        
        FB_maxLength(18)
        
        FB_secureTextEntry(true)
        
    }
}
