//
//  FBUserBean.swift
//  ZUserKit
//
//  Created by three stone 王 on 2019/3/15.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import ObjectMapper

@objc (FBUserBean)
public class FBUserBean: NSObject, Mappable ,NSCoding {
    public required init?(coder aDecoder: NSCoder) {
        
        phone = aDecoder.decodeObject(forKey: "phone") as! String
        
        encoded = aDecoder.decodeObject(forKey: "encoded") as! String
        
        headImg = aDecoder.decodeObject(forKey: "headImg") as! String
        
        nickname = aDecoder.decodeObject(forKey: "nickname") as! String
        
        sex = Int(aDecoder.decodeInt64(forKey: "sex"))
        
        signature = aDecoder.decodeObject(forKey: "signature") as! String
        
        birthday = aDecoder.decodeObject(forKey: "birthday") as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(phone, forKey: "phone")
        
        aCoder.encode(encoded, forKey: "encoded")
        
        aCoder.encode(headImg, forKey: "headImg")
        
        aCoder.encode(nickname, forKey: "nickname")
        
        aCoder.encode(sex, forKey: "sex")
        
        aCoder.encode(signature, forKey: "signature")
        
        aCoder.encode(birthday, forKey: "birthday")
    }
    
    
    @objc public var phone: String = ""
    
    @objc public var encoded: String = ""
    
    @objc public var headImg: String = ""
    
    @objc public var nickname: String = ""
    
    @objc public var sex: Int = Int.max
    
    public var gender: FBGenderType {
        
        return FBGenderType(temp: sex)
    }
    
    @objc public var signature: String = ""
    
    @objc public var birthday: String = ""
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        
        nickname <- map["nickname"]
        
        headImg  <- map["headImg"]
        
        sex  <- map["sex"]
        
        encoded  <- map["encoded"]
        
        signature  <- map["signature"]
        
        phone <- map["phone"]
        
        birthday <- map["birthday"]
    }
    
    public override init() { }
}
