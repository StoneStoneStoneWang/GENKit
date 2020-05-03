//
//  FBUserCenterViewModel.swift
//  FBBridge
//
//  Created by 王磊 on 2020/3/30.
//  Copyright © 2020 王磊. All rights reserved.
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

@objc public final class FBUserCenterBean: NSObject {
    
    @objc public var type: FBUserCenterType = .userInfo
    
    @objc public var title: String = ""
    
    @objc public static func createUserCenter(_ type: FBUserCenterType ,title: String) -> FBUserCenterBean {
        
        let profile = FBUserCenterBean()
        
        profile.type = type
        
        profile.title = title
        
        return profile
    }
    
    static public func createUserCenterTypes() -> [FBUserCenterBean] {
        
        var result: [FBUserCenterBean] = []
        
        for item in FBUserCenterType.types {
            
            result += [FBUserCenterBean.createUserCenter(item, title: item.title)]
        }
        
        return result
    }
    private override init() {
        
    }
}

@objc (FBUserCenterType)
public enum FBUserCenterType : Int{
    
    case about
    
    case userInfo
    
    case setting
    
    case contactUS
    
    case privacy
    
    case focus
    
    case myCircle
    
    case order
    
    case address
    
    case characters
    
    case feedBack
    
    case share
    
    case service
    
    case header
    
    case version
    
    case car
}

extension FBUserCenterType {
    
    static var types: [FBUserCenterType] {
        
        if FBConfigure.fetchPType() == .estate {
            
            return [userInfo,.car,.privacy,.feedBack,.version,.setting]
        }
        
        return [userInfo,.contactUS,.feedBack,.setting]
    }
    
    var cellHeight: CGFloat {
        
        switch self {
            
        case .header: return 100
            
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
            
        case .address: return "我的地址"
            
        case .order: return "订单管理"
            
        case .characters: return "角色信息"
            
        case .feedBack: return "用户反馈"
            
        case .share: return "分享"
            
        case .service: return "服务热线"
            
        case .version: return "当前版本"
            
        case .car: return "车辆管理"
        default: return ""
            
        }
    }
}

struct FBUserCenterViewModel: FBViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<FBUserCenterBean>
        
        let itemSelect: ControlEvent<IndexPath>
    }
    
    struct WLOutput {
        
        let zip: Observable<(FBUserCenterBean,IndexPath)>
        
        let tableData: BehaviorRelay<[FBUserCenterBean]> = BehaviorRelay<[FBUserCenterBean]>(value: [])
        
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
        
        self.output.tableData.accept(FBUserCenterBean.createUserCenterTypes())
    }
}

