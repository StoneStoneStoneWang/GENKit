//
//  UITextField+WL.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/17.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    @objc (FB_backgroundColor:)
    public func FB_backgroundColor(_ color: UIColor) {
        
        backgroundColor = color
    }
    @objc (FB_font:)
    public func FB_font(_ font: UIFont) {
        
        self.font = font
    }
    @objc (FB_textColor:)
    public func FB_textColor(_ color: UIColor) {
        
        textColor = color
    }
    @objc (FB_textAlignment:)
    public func FB_textAlignment(_ alignment: NSTextAlignment) {
        
        textAlignment = alignment
    }
    @objc (FB_keyboardType:)
    public func FB_keyboardType(_ keyboardType: UIKeyboardType) {
        
        self.keyboardType = keyboardType
    }
    @objc (FB_clearButtonMode:)
    public func FB_clearButtonMode(_ clearButtonMode: UITextField.ViewMode) {
        
        self.clearButtonMode = clearButtonMode
        
    }
    @objc (FB_returnKeyType:)
    public func FB_returnKeyType(_ returnKeyType: UIReturnKeyType) {
        
        self.returnKeyType = returnKeyType
    }
    @objc (FB_rightViewMode:)
    public func FB_rightViewMode(_ rightViewMode: UITextField.ViewMode) {
        
        self.rightViewMode = rightViewMode
    }
    @objc (FB_leftViewMode:)
    public func FB_leftViewMode(_ leftViewMode: UITextField.ViewMode) {
        
        self.leftViewMode = leftViewMode
    }
    @objc (FB_leftView:)
    public func FB_leftView(_ leftView: UIView) {
        
        self.leftView = leftView
    }
    @objc (FB_rightView:)
    public func FB_rightView(_ rightView: UIView) {
        
        self.rightView = rightView
    }
}

public typealias FBShouldReturn = () -> Bool

public typealias FBShouldClear = () -> Bool

extension UITextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    fileprivate var shouldReturn: FBShouldReturn! {
        set {
            
            objc_setAssociatedObject(self, "shouldReturn", newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            
            return objc_getAssociatedObject(self, "shouldReturn") as? FBShouldReturn
        }
    }
    @objc (FB_shouldReturn:)
    public func FB_shouldReturn(_ shouldReturn: @escaping () -> Bool) {
        
        self.shouldReturn = shouldReturn
    }
    @objc (textFieldShouldReturn:)
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if shouldReturn == nil {
            
            return true
        }
        
        return shouldReturn!()
    }
    
    fileprivate var shouldClear: FBShouldClear! {
        
        set {
            
            objc_setAssociatedObject(self, "shouldClear", newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            
            return objc_getAssociatedObject(self, "shouldClear") as? FBShouldClear
        }
    }
    @objc (FB_shouldClear:)
    public func FB_shouldClear(_ shouldClear: @escaping () -> Bool) {
        
        self.shouldClear = shouldClear
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if shouldClear == nil {
            
            return true
        }
        
        return shouldClear!()
    }
}

