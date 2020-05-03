//
//  GENProfileViewModel.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/27.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENViewModel
import RxCocoa
import RxSwift
import GENBean
import GENSign
import GENApi
import GENRReq
import GENCache
import GENObservableMapper

@objc public final class GENProfileBean: NSObject {
    
    @objc public var type: GENProfileType = .space
    
    @objc public var title: String = ""
    
    @objc public static func createProfile(_ type: GENProfileType ,title: String) -> GENProfileBean {
        
        let profile = GENProfileBean()
        
        profile.type = type
        
        profile.title = title
        
        return profile
    }
    
    static public func createProfileTypes(_ hasSpace: Bool) -> [GENProfileBean] {
        
        var result: [GENProfileBean] = []
        
        if hasSpace {
            
            for item in GENProfileType.spaceTypes {
                
                result += [GENProfileBean.createProfile(item, title: item.title)]
            }
            
        } else {
            
            for item in GENProfileType.types {
                
                result += [GENProfileBean.createProfile(item, title: item.title)]
            }
        }
        
        return result
    }
    private override init() {
        
    }
}

@objc (GENProfileType)
public enum GENProfileType : Int{
    
    case about
    
    case userInfo
    
    case setting
    
    case contactUS
    
    case privacy
    
    case focus
    
    case space
    
    case myCircle
    
    case order
    
    case address
    
    case characters
    
    case feedBack
    
    case favor
}

extension GENProfileType {
    
    static var spaceTypes: [GENProfileType] {
        
        if GENSign.fetchPType() == .lock {
            
            return [.space,userInfo,.order,.address,.favor,.space,.contactUS,.privacy,.about,.space,.feedBack,.setting]
        }
        
        return [.space,userInfo,.space,.contactUS,.privacy,.about,.space,.feedBack,.setting]
        
    }
    
    static var types: [GENProfileType] {
        
        if GENSign.fetchPType() == .lock {
            
            return [userInfo,.order,.address,.favor,.contactUS,.privacy,.about,.feedBack,.setting]
        }
        
        return [userInfo,.contactUS,.privacy,.about,.feedBack,.setting]
    }
    
    var cellHeight: CGFloat {
        
        switch self {
        case .space: return 10
            
        default: return 55
        }
    }
    
    var title: String {
        
        switch self {
            
        case .about: return "关于我们"
            
        case .contactUS: return "联系我们"
            
        case .userInfo: return "用户资料"
            
        case .setting: return "设置"
            
        case .privacy: return "隐私政策"
            
        case .focus: return "我的关注"
            
        case .myCircle: return "我的发布"
            
        case .address: return "地址管理"
            
        case .order: return "订单管理"
            
        case .characters: return "角色信息"
            
        case .feedBack: return "意见建议"
            
        case .favor: return "我的收藏"
            
        default: return ""
            
        }
    }
}

struct GENProfileViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<GENProfileBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let hasSpace: Bool
    }
    
    struct WLOutput {
        
        let zip: Observable<(GENProfileBean,IndexPath)>
        
        let tableData: BehaviorRelay<[GENProfileBean]> = BehaviorRelay<[GENProfileBean]>(value: [])
        
        let userInfo: Observable<GENUserBean?>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let userInfo: Observable<GENUserBean?> = GENUserInfoCache.default.rx.observe(GENUserBean.self, "userBean")
        
        GENUserInfoCache.default.userBean = GENUserInfoCache.default.queryUser()
        
        GENDictResp(GENApi.fetchProfile)
            .mapObject(type: GENUserBean.self)
            .map({ GENUserInfoCache.default.saveUser(data: $0) })
            .subscribe(onNext: { (_) in })
            .disposed(by: disposed)
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        self.output = WLOutput(zip: zip, userInfo: userInfo)
        
        self.output.tableData.accept(GENProfileBean.createProfileTypes(input.hasSpace))
    }
}

