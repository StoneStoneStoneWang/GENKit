//
//  GENUserInfoCache.swift
//  ZUserKit
//
//  Created by three stone 王 on 2019/3/15.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENBean
import GENYY

@objc (GENUserInfoCache)
public final class GENUserInfoCache: NSObject {
    @objc (shared)
    public static let `default`: GENUserInfoCache = GENUserInfoCache()
    
    private override init() {
        
        if let info = Bundle.main.infoDictionary {
            
            GENYY.shared().createCache(info["CFBundleDisplayName"] as? String ?? "GENUserInfoCache" )
        }
    }
    @objc (userBean)
    public dynamic var userBean: GENUserBean = GENUserBean()
}

extension GENUserInfoCache {
    
    public func saveUser(data: GENUserBean) -> GENUserBean {
        
        if GENAccountCache.default.uid != "" {
            
            GENYY.shared().saveObj(data, withKey: "user_" + GENAccountCache.default.uid)
            
            userBean = data
        }
        
        return data
    }
    
    @objc public func queryUser() -> GENUserBean  {
        
        if GENAccountCache.default.uid != "" {
            
            if let user = GENYY.shared().fetchObj("user_" + GENAccountCache.default.uid) {
                
                userBean = user as! GENUserBean
                
                return userBean
            }
        }
        
        return GENUserBean()
    }
}
