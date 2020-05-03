//
//  FBBlackBean.swift
//  HZTC
//
//  Created by three stone 王 on 2019/3/21.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

@objc (FBBlackBean)
public class FBBlackBean: NSObject,Mappable,IdentifiableType {
    @objc public var identity: String = ""
    
    public typealias Identity = String
    
    @objc public var intime: Int = Int.max
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        
        identity <- map["encoded"]
        
        encoded <- map["encoded"]
        
        intime <- map["intime"]
        
        users <- map["users"]
        
        tableName <- map["tableName"]
        
        oUsEncoded <- map["oUsEncoded"]
        
        targetEncoded <- map["targetEncoded"]
        
        usEncoded <- map["usEncoded"]
        
        content <- map["content"]
    }
     @objc public var users: FBUserBean!
    
     @objc public var tableName: String = ""
    
     @objc public var oUsEncoded: String = ""
    
     @objc public var targetEncoded: String = ""
    
     @objc public var usEncoded: String = ""
    
     @objc public var content: String = ""
    
     @objc public var encoded: String = ""
}
