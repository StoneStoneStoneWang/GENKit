//
//  FBUserInfoCache.swift
//  ZUserKit
//
//  Created by three stone 王 on 2019/3/15.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBBean
import FBYY

@objc (FBUserInfoCache)
public final class FBUserInfoCache: NSObject {
    @objc (shared)
    public static let `default`: FBUserInfoCache = FBUserInfoCache()
    
    private override init() {
        
        if let info = Bundle.main.infoDictionary {
            
            FBYY.shared().createCache(info["CFBundleDisplayName"] as? String ?? "FBUserInfoCache" )
        }
    }
    @objc (userBean)
    public dynamic var userBean: FBUserBean = FBUserBean()
}

extension FBUserInfoCache {
    
    public func saveUser(data: FBUserBean) -> FBUserBean {
        
        if FBAccountCache.default.uid != "" {
            
            FBYY.shared().saveObj(data, withKey: "user_" + FBAccountCache.default.uid)
            
            userBean = data
        }
        
        return data
    }
    
    @objc public func queryUser() -> FBUserBean  {
        
        if FBAccountCache.default.uid != "" {
            
            if let user = FBYY.shared().fetchObj("user_" + FBAccountCache.default.uid) {
                
                userBean = user as! FBUserBean
                
                return userBean
            }
        }
        
        return FBUserBean()
    }
}
