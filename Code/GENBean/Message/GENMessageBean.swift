//
//  GENMessageBean.swift
//  GENBean
//
//  Created by 王磊 on 2020/4/14.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

@objc (GENMessageBean)
public final class GENMessageBean: NSObject,Mappable,IdentifiableType {
    
    public var identity: String = NSUUID().uuidString
    
    public typealias Identity = String
    
    required public init?(map: Map) { }
    
    @objc public override init() { }
    
    public func mapping(map: Map) {
        
        intime  <- map["intime"]
        
        encoded  <- map["encoded"]
        
        dsct  <- map["dsct"]
        
        isread  <- map["isread"]
        
        usEncoded  <- map["usEncoded"]
        
        mid  <- map["id"]
    }
    
    @objc public var intime: String = ""
    
    @objc public var dsct: String = ""
    
    @objc public var encoded: String = ""

    @objc public var isread: Bool = false
    
    @objc public var usEncoded: String = ""
    
    @objc public var mid: Int = 0
}

