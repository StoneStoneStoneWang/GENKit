//
//  FBResult.swift
//  FBResultDemo
//
//  Created by three stone 王 on 2019/5/21.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import ObjectMapper

public enum FBResult {
    
    case begin(_ msg: String)
    
    case ok(_ msg: String)
    
    case failed(_ msg: String)
    
    case empty
    
    case logined
    
    case smsOk(isEnabled: Bool, title: String)
    
    case aliToken(_ token: Mappable)
    
    case updateUserInfoSucc(_ user: Mappable ,msg: String)
    
    case fetchList(_ list: [Mappable])
    
    case operation(_ obj: Mappable)
    
    case fetchSomeObject(_ obj: AnyObject)
}
