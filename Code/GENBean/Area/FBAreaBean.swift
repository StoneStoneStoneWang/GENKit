//
//  FBAreaBean.swift
//  DAddressDemo
//
//  Created by three stone 王 on 2019/7/16.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

@objc (FBAreaBean)
public class FBAreaBean: NSObject,Mappable ,IdentifiableType {
    
    public var identity: String = NSUUID().uuidString
    
    public typealias Identity = String
    
    @objc public var areaId: Int = 0
    
    @objc public var aid: String = ""
    
    @objc public var pid: Int = 0
    
    @objc public var name: String = ""
    
    @objc public var alif: String = ""
    
    @objc public var areacode: String = ""
    
    @objc public var arealevel: Int = 0
    
    @objc public var typename: String = ""
    
    @objc public var addrList: [FBAreaBean] = []
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        
        areaId <- map["id"]
        
        aid <- map["aid"]
        
        pid <- map["pid"]
        
        name <- map["name"]
        
        alif <- map["alif"]
        
        areacode <- map["areacode"]
        
        arealevel <- map["arealevel"]
        
        typename <- map["typename"]
        
        addrList <- map["addrList"]
    }
    
    @objc public var isSelected: Bool = false
    
    @objc public override init() { }
}
