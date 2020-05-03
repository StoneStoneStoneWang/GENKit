//
//  FBAccountBean.swift
//  ZUserKit
//
//  Created by three stone 王 on 2019/3/15.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import ObjectMapper

public struct FBAccountBean: Mappable {
    
    public var token: String = ""
    
    public var phone: String = ""
    
    public var encoded: Int = 0
    
    public var headImg: String = ""
    
    public var nickname: String = ""
    
    public var sex: Int = Int.max
    
    public var signature: String = ""
    
    public var birthday: String = ""
    
    public init?(map: Map) { }
    
    public mutating func mapping(map: Map) {
        
        nickname <- map["nickname"]
        
        headImg  <- map["headImg"]
        
        sex <- map["sex"]
        
        encoded  <- map["id"]
        
        signature  <- map["signature"]
        
        phone <- map["phone"]
        
        birthday <- map["birthday"]
        
        token  <- map["token"]
    }
    
    public init() { }
}

