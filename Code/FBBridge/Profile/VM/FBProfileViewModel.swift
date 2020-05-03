//
//  FBProfileViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/27.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import FBBean
import FBSign
import FBApi
import FBRReq
import FBCache
import FBObservableMapper

@objc public final class FBProfileBean: NSObject {
    
    @objc public var type: FBProfileType = .space
    
    @objc public var title: String = ""
    
    @objc public static func createProfile(_ type: FBProfileType ,title: String) -> FBProfileBean {
        
        let profile = FBProfileBean()
        
        profile.type = type
        
        profile.title = title
        
        return profile
    }
    
    static public func createProfileTypes(_ hasSpace: Bool) -> [FBProfileBean] {
        
        var result: [FBProfileBean] = []
        
        if hasSpace {
            
            for item in FBProfileType.spaceTypes {
                
                result += [FBProfileBean.createProfile(item, title: item.title)]
            }
            
        } else {
            
            for item in FBProfileType.types {
                
                result += [FBProfileBean.createProfile(item, title: item.title)]
            }
        }
        
        return result
    }
    private override init() {
        
    }
}

@objc (FBProfileType)
public enum FBProfileType : Int{
    
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

extension FBProfileType {
    
    static var spaceTypes: [FBProfileType] {
        
        if FBConfigure.fetchPType() == .estate {
            
            return [.space,userInfo,.order,.address,.favor,.space,.contactUS,.privacy,.about,.space,.feedBack,.setting]
        }
        
        return [.space,userInfo,.space,.contactUS,.privacy,.about,.space,.feedBack,.setting]
        
    }
    
    static var types: [FBProfileType] {
        
        if FBConfigure.fetchPType() == .estate {
            
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

struct FBProfileViewModel: FBViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<FBProfileBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let hasSpace: Bool
    }
    
    struct WLOutput {
        
        let zip: Observable<(FBProfileBean,IndexPath)>
        
        let tableData: BehaviorRelay<[FBProfileBean]> = BehaviorRelay<[FBProfileBean]>(value: [])
        
        let userInfo: Observable<FBUserBean?>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let userInfo: Observable<FBUserBean?> = FBUserInfoCache.default.rx.observe(FBUserBean.self, "userBean")
        
        FBUserInfoCache.default.userBean = FBUserInfoCache.default.queryUser()
        
        FBDictResp(FBApi.fetchProfile)
            .mapObject(type: FBUserBean.self)
            .map({ FBUserInfoCache.default.saveUser(data: $0) })
            .subscribe(onNext: { (_) in })
            .disposed(by: disposed)
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        self.output = WLOutput(zip: zip, userInfo: userInfo)
        
        self.output.tableData.accept(FBProfileBean.createProfileTypes(input.hasSpace))
    }
}

