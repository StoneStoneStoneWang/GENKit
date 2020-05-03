//
//  FBCommentBean.swift
//  ZBean
//
//  Created by three stone 王 on 2019/8/30.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources
@objc (FBCommentBean)
public final class FBCommentBean: NSObject,Mappable,IdentifiableType {
    
    public var identity: String = ""
    
    public typealias Identity = String
    
    required public init?(map: Map) { }
    
    @objc public override init() { }
    
    public func mapping(map: Map) {
        
        intime  <- map["intime"]
        
        content  <- map["content"]
        
        users  <- map["users"]
        
        encoded  <- map["encoded"]
        
        identity  <- map["encoded"]
    }
    
    @objc public var intime: Int = Int.max
    
    @objc public var content: String = ""
    
    @objc public var users: FBUserBean!
    
    @objc public var encoded: String = ""
    
    @objc public var type: WLCommentType = .normal
    
    @objc public enum WLCommentType: Int {
        
        case empty
        
        case normal
        
        case noMore
        
        case failed
        
        case total
        
        case rectangle
    }
}

