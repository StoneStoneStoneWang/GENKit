//
//  FBTranslateApi.swift
//  ZApi
//
//  Created by three stone 王 on 2020/3/16.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import FBObservableReq
import Alamofire

@objc (FBTranslateStyle)
public enum FBTranslateStyle: Int {
    
    case id // 🇮🇩 印尼语
    
    case ko // 🇰🇷 韩语
    
    case it // 🇮🇹 意大利语
    
    case fr // 🇫🇷 法语
    
    case es // 🇪🇸 西班牙语
    
    case ja // 🇯🇵 日语
    
    case sv // 🇸🇪 瑞典语
    
    case th // 🇹🇭 泰语
}

extension FBTranslateStyle {
    
    public var title: String {
        
        switch self {
        case .id: return "id"
            
        case .ko: return "ko"
            
        case .it: return "it"
            
        case .fr: return "fr"
            
        case .es: return "es"
            
        case .ja: return "ja"
            
        case .sv: return "sv"
            
        case .th: return "th"
        }
    }
}

public enum FBTranslateApi {
    
    case translateFromCNToKO(_ text: String ) // 韩语-> 中文
    
    case translateFromKOToCN(_ text: String ) // 中文 -> 韩语
    
    case translateFromTerToCN(_ text: String ) // 印尼语-> 中文
    
    case translateFromCNToTer(_ text: String) // 中文 -> 印尼语
    
    case translateFromCNTo(_ text: String ,style: FBTranslateStyle)
    
    case translateToCN(_ text: String ,style: FBTranslateStyle)
}

extension FBTranslateApi: FBObservableReq {
    
    public var host: String { return "" }
    
    public var reqName: String {
        
        return ""
    }
    
    public var params: Dictionary<String, Any> {
        
        switch self {
            
        case .translateToCN(let text, style: let style): return ["from":style.title,"to":"zh-cn","text":text]
            
        case .translateFromCNTo(let text, style: let style): return ["from":"zh-cn","to":style.title,"text":text]
            
        default: return [:]
        }
    }
    
    public var headers: Dictionary<String, String> {
        
        return [:]
    }
    
    public var method: HTTPMethod {
        
        return .post
    }
}
