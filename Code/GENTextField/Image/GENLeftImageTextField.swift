//
//  GENLeftImageTextField.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/22.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import WLToolsKit

// MARK: Vcode

@objc (GENLeftImageTextField)
open class GENLeftImageTextField: GENBaseTextField {
    
    fileprivate final let leftImageView: UIImageView = UIImageView()
    
    @objc (imageName)
    open var imageName: String = "" {
        
        willSet {
            
            guard !newValue.isEmpty else { return }
            
            leftViewMode = .always
            
            let image = UIImage(named: newValue)
            
            leftImageView.image = image
            
            leftImageView.contentMode = .scaleAspectFit
            
            leftView = leftImageView
        }
    }
    
    @objc (leftImageFrame)
    open var leftImageFrame: CGRect = CGRect(x: 0, y: 0, width: 80, height: 48) {
        
        willSet {
            
            leftImageView.frame = newValue
        }
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        return leftImageFrame
    }
}

// MARK: password
@objc (GENPasswordImageTextFiled)
public final class GENPasswordImageTextFiled: GENLeftImageTextField {
    
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
}
// MARK: Vcode
@objc (GENVCodeImageTextField)
public final class GENVCodeImageTextField: GENLeftImageTextField {
    
    public final let vcodeItem: UIButton = UIButton(type: .custom).then {
        
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        $0.setTitle("获取验证码", for: .normal)
    }
    
    public override func commitInit() {
        super.commitInit()
        
        rightView = vcodeItem
        
        rightViewMode = .always
        
        vcodeItem.sizeToFit()
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.rightViewRect(forBounds: bounds)
        
        return CGRect(x: rect.minX - 20, y: rect.minY, width: rect.width, height: rect.height)
    }
}

