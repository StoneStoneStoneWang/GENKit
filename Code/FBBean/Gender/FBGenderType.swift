//
//  FBGenderType.swift
//  ZBean
//
//  Created by three stone 王 on 2019/8/22.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation

@objc(FBGenderType)
public enum FBGenderType: Int ,Codable {
    
    case unknown = 0
    
    case male = 1
    
    case female = 2
    
    init(temp: Int) {
        
        switch temp {
        case 1: self = .male
            
        case 2: self = .female
            
        default: self = .unknown
            
        }
    }
}

extension FBGenderType {
    
    public var gender: String {
        
        switch self {
        case .unknown: return "未设置"
        case .male: return "男"
        case .female: return "女"
        }
    }
}
