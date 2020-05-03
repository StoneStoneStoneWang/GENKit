//
//  FBAddressBean.swift
//  DStoreDemo
//
//  Created by three stone 王 on 2019/7/16.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

@objc (FBAddressBean)
public class FBAddressBean: NSObject,Mappable,IdentifiableType {
    public var identity: String = ""
    
    public typealias Identity = String
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        
        id <- map["id"]
        
        identity <- map["encoded"]
        
        encoded <- map["encoded"]
        
        intime <- map["intime"]
        
        isdel <- map["isdel"]
        
        phone <- map["phone"]
        
        plcl <- map["plcl"]
        
        plclne <- map["plclne"]
        
        city <- map["city"]
        
        cityne <- map["cityne"]
        
        region <- map["region"]
        
        name <- map["name"]
        
        addr <- map["addr"]
        
        cityne <- map["cityne"]
        
        regionne <- map["regionne"]
        
    }
    
    @objc public var id: Int = 0
    
    @objc public var intime: Int = Int.max
    
    @objc public var isdel: Bool = false
    
    @objc public var phone: String = ""
    
    @objc public var plcl: Int = 0
    
    @objc public var plclne: String = ""
    
    @objc public var city: Int = 0
    
    @objc public var cityne: String = ""
    
    @objc public var region: Int = 0
    
    @objc public var regionne: String = ""
    
    @objc public var encoded: String = ""
    
    @objc public var name: String = ""
    
    @objc public var addr: String = ""
    
    @objc public override init() { }
}
