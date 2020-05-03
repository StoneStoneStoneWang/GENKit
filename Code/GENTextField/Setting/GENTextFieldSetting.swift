//
//  GENTextFieldSetting.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/17.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    @objc (GEN_backgroundColor:)
    public func GEN_backgroundColor(_ color: UIColor) {
        
        backgroundColor = color
    }
    @objc (GEN_font:)
    public func GEN_font(_ font: UIFont) {
        
        self.font = font
    }
    @objc (GEN_textColor:)
    public func GEN_textColor(_ color: UIColor) {
        
        textColor = color
    }
    @objc (GEN_textAlignment:)
    public func GEN_textAlignment(_ alignment: NSTextAlignment) {
        
        textAlignment = alignment
    }
    @objc (GEN_keyboardType:)
    public func GEN_keyboardType(_ keyboardType: UIKeyboardType) {
        
        self.keyboardType = keyboardType
    }
    @objc (GEN_clearButtonMode:)
    public func GEN_clearButtonMode(_ clearButtonMode: UITextField.ViewMode) {
        
        self.clearButtonMode = clearButtonMode
        
    }
    @objc (GEN_returnKeyType:)
    public func GEN_returnKeyType(_ returnKeyType: UIReturnKeyType) {
        
        self.returnKeyType = returnKeyType
    }
    @objc (GEN_rightViewMode:)
    public func GEN_rightViewMode(_ rightViewMode: UITextField.ViewMode) {
        
        self.rightViewMode = rightViewMode
    }
    @objc (GEN_leftViewMode:)
    public func GEN_leftViewMode(_ leftViewMode: UITextField.ViewMode) {
        
        self.leftViewMode = leftViewMode
    }
    @objc (GEN_leftView:)
    public func GEN_leftView(_ leftView: UIView) {
        
        self.leftView = leftView
    }
    @objc (GEN_rightView:)
    public func GEN_rightView(_ rightView: UIView) {
        
        self.rightView = rightView
    }
}

public typealias GENShouldReturn = () -> Bool

public typealias GENShouldClear = () -> Bool

extension UITextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    fileprivate var shouldReturn: GENShouldReturn! {
        set {
            
            objc_setAssociatedObject(self, "shouldReturn", newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            
            return objc_getAssociatedObject(self, "shouldReturn") as? GENShouldReturn
        }
    }
    @objc (GEN_shouldReturn:)
    public func GEN_shouldReturn(_ shouldReturn: @escaping () -> Bool) {
        
        self.shouldReturn = shouldReturn
    }
    @objc (textFieldShouldReturn:)
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if shouldReturn == nil {
            
            return true
        }
        
        return shouldReturn!()
    }
    
    fileprivate var shouldClear: GENShouldClear! {
        
        set {
            
            objc_setAssociatedObject(self, "shouldClear", newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            
            return objc_getAssociatedObject(self, "shouldClear") as? GENShouldClear
        }
    }
    @objc (GEN_shouldClear:)
    public func GEN_shouldClear(_ shouldClear: @escaping () -> Bool) {
        
        self.shouldClear = shouldClear
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if shouldClear == nil {
            
            return true
        }
        
        return shouldClear!()
    }
}

