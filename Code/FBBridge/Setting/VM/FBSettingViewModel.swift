//
//  FBSettingViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import FBCache
import FBSign

@objc public final class FBSettingBean: NSObject {
    
    @objc public var type: FBSettingType = .space
    
    @objc public var title: String = ""
    
    @objc public var subTitle: String = ""
    
    @objc public static func createSetting(_ type: FBSettingType ,title: String ,sub: String) -> FBSettingBean {
        
        let setting = FBSettingBean()
        
        setting.type = type
        
        setting.title = title
        
        setting.subTitle = sub
        
        return setting
    }
    
    static func createTabledata(_ hasspace: Bool ) -> [FBSettingBean] {
        
        var result: [FBSettingBean] = []
        
        if hasspace {
            
            for item in FBSettingType.spaceTypes {
                
                result += [FBSettingBean.createSetting(item, title: item.title, sub: "")]
            }
            
        } else {
            
            for item in FBSettingType.types {
                
                result += [FBSettingBean.createSetting(item, title: item.title, sub: "")]
            }
        }
        
        return result
    }
    private override init() { }
}

@objc (FBSettingType)
public enum FBSettingType: Int {
    
    case pwd  = 0 // 未登录
    
    case password = 1// 已登录
    
    case logout = 2
    
    case clear = 3
    
    case push = 4
    
    case space = 5
    
    case black = 6
}

extension FBSettingType {
    
    static var spaceTypes: [FBSettingType] {
        
        if FBAccountCache.default.isLogin() {
            
            if FBConfigure.fetchPType() == .estate {
                
                return [.space,.password,.space,.clear,.push,.space,.logout]
            }
        }
        return [.space,.pwd,.space,.clear,.push]
    }
    static var types: [FBSettingType] {
        
        if FBAccountCache.default.isLogin() {
            
            if FBConfigure.fetchPType() == .estate {
                
                return [.password,.black,.clear,.push,.logout]
            }
        }
        
        return [.pwd,.clear,.push]
    }
    
    
    public var title: String {
        
        switch self {
            
        case .pwd: return "忘记密码"
            
        case .password: return "修改密码"
            
        case .logout: return "退出登录"
            
        case .clear: return "清理缓存"
            
        case .push: return "推送设置"
            
        case .black: return "黑名单"
            
        default: return ""
            
        }
    }
    
    var cellHeight: CGFloat {
        
        switch self {
        case .space: return 10
            
        default: return 55
        }
    }
}

public struct FBSettingViewModel: FBViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        
        let modelSelect: ControlEvent<FBSettingBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let hasSpace: Bool
    }
    public struct WLOutput {
        
        let zip: Observable<(FBSettingBean,IndexPath)>
        
        let tableData: BehaviorRelay<[FBSettingBean]> = BehaviorRelay<[FBSettingBean]>(value: [])
    }
    
    init(_ input: WLInput) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        self.output = WLOutput(zip: zip)
        
        self.output.tableData.accept(FBSettingBean.createTabledata(input.hasSpace))
    }
}

