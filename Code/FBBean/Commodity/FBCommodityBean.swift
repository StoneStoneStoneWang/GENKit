//
//  FBCommodityBean.swift
//  DStoreDemo
//
//  Created by three stone 王 on 2019/7/18.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources
import WLToolsKit

@objc (FBCommodityBean)
public class FBCommodityBean: NSObject, Mappable , IdentifiableType{
    
    public var identity: String = ""
    
    public typealias Identity = String
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        
        identity <- map["encoded"]
        
        intime <- map["intime"]
        
        content  <- map["content"]
        
        isLaud  <- map["isLaud"]
        
        countLaud  <- map["countLaud"]
        
        tag  <- map["tag"]
        
        users  <- map["users"]
        
        countComment  <- map["countComment"]
        
        projectId  <- map["projectId"]
        
        encoded  <- map["encoded"]
    }
    
    @objc public var projectId: String = ""
    
    @objc public var encoded: String = ""
    
    @objc public var intime: Int = Int.max
    
    @objc public var content: String = ""
    
    @objc public var isLaud: Bool = false
    
    @objc public var countLaud: Int = Int.max
    
    @objc public var tag: String = ""
    
    @objc public var users: FBUserBean!
    
    @objc public var countComment: Int = Int.max
    
    @objc public var contentMap: [FBKeyValueBean] {
        
        let res = WLJsonCast.cast(argu: content) as! [[String: String]]
        
        return res.map({ FBKeyValueBean(JSON: $0)! })
    }
    
    @objc public var imgs: [FBKeyValueBean] {
        
        var result: [FBKeyValueBean] = []
        
        for item in contentMap {
            
            if item.type == "image" {
                
                result += [item]
            }
        }
        
        if result.isEmpty {
            
            for item in contentMap {
                
                if item.type == "txt" && item.value.contains("Image:") {
                    
                    result += [item]
                }
            }
        }
        
        return result
    }
}
