//
//  ZCheck.swift
//  ZCheck
//
//  Created by three stone 王 on 2019/8/25.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENResult
import WLToolsKit

public func GENCheckUsernameAndPassword(_ username: String ,password: String) -> GENResult {
    
    if username.isEmpty || username.wl_isEmpty {
        
        return GENResult.failed("请输入手机号")
    }
    
    if !String.validPhone(phone: username) {
        return GENResult.failed("请输入11位手机号")
    }
    
    if password.isEmpty || password.wl_isEmpty {
        
        return GENResult.failed("请输入6-18密码")
    }
    
    if password.length < 6 {
        
        return GENResult.failed("请输入6-18密码")
    }
    
    return GENResult.ok("验证成功")
}

public func GENCheckUsernameAndVCode(_ mobile: String ,vcode: String) -> GENResult {
    
    if mobile.isEmpty || mobile.wl_isEmpty {
        
        return GENResult.failed("手机号不能为空")
    }
    if !String.validPhone(phone: mobile) {
        
        return GENResult.failed( "请输入正确手机号")
    }
    
    if vcode.isEmpty || vcode.wl_isEmpty {
        
        return GENResult.failed( "请输入6位验证码")
    }
    
    if vcode.length < 6 {
        
        return GENResult.failed( "请输入6位验证码")
    }
    
    return GENResult.ok( "")
}
public func GENCheckUsername(_ mobile: String ) -> GENResult {
    
    if mobile.isEmpty || mobile.wl_isEmpty {
        
        return GENResult.failed("手机号不能为空")
    }
    if !String.validPhone(phone: mobile) {
        
        return GENResult.failed( "请输入正确手机号")
    }
    return GENResult.ok("")
}

public func smsResult(count: Int) -> (Bool ,String) {
    
    if count <= 0 { return  (true ,"获取验证码") }
        
    else { return (false ,"(\(count)s)")}
}

public func GENCheckPasswordForget(_ mobile: String ,vcode: String ,password: String) -> GENResult {
    
    if mobile.isEmpty || mobile.wl_isEmpty {
        
        return GENResult.failed("手机号不能为空")
    }
    if !String.validPhone(phone: mobile) {
        
        return GENResult.failed( "请输入正确手机号")
    }
    
    if vcode.isEmpty || vcode.wl_isEmpty {
        
        return GENResult.failed( "请输入6位验证码")
    }
    
    if vcode.length < 6 {
        
        return GENResult.failed( "请输入6位验证码")
    }
    
    if password.isEmpty || password.wl_isEmpty {
        
        return GENResult.failed( "请输入6-18位密码")
    }
    
    if password.length < 6 {
        
        return GENResult.failed( "请输入6-18位密码")
    }
    
    return GENResult.ok( "")
}

public func GENCheckPasswordModify(_ oldpassword: String,password: String ,passwordAgain: String) -> GENResult {
    
    if oldpassword.isEmpty || oldpassword.wl_isEmpty {
        
        return GENResult.failed( "请输入6-18位旧密码")
    }
    
    if oldpassword.length < 6 {
        
        return GENResult.failed( "请输入6-18位旧密码")
    }
    if password.isEmpty || password.wl_isEmpty {
        
        return GENResult.failed( "请输入6-18位新密码")
    }
    
    if password.length < 6 {
        
        return GENResult.failed( "请输入6-18位新密码")
    }
    
    if passwordAgain.isEmpty || passwordAgain.wl_isEmpty {
        
        return GENResult.failed( "请输入6-18位确认密码")
    }
    
    if passwordAgain.length < 6 {
        
        return GENResult.failed( "请输入6-18位确认密码")
    }
    
    if password != passwordAgain {
        return GENResult.failed( "新密码和确认密码不一致")
    }
    
    return GENResult.ok( "")
}
