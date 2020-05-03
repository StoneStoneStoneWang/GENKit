//
//  GENUserCenterViewModel.swift
//  GENBridge
//
//  Created by 王磊 on 2020/3/30.
//  Copyright © 2020 王磊. All rights reserved.
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

@objc public final class GENUserCenterBean: NSObject {
    
    @objc public var type: GENUserCenterType = .userInfo
    
    @objc public var title: String = ""
    
    @objc public static func createUserCenter(_ type: GENUserCenterType ,title: String) -> GENUserCenterBean {
        
        let profile = GENUserCenterBean()
        
        profile.type = type
        
        profile.title = title
        
        return profile
    }
    
    static public func createUserCenterTypes() -> [GENUserCenterBean] {
        
        var result: [GENUserCenterBean] = []
        
        for item in GENUserCenterType.types {
            
            result += [GENUserCenterBean.createUserCenter(item, title: item.title)]
        }
        
        return result
    }
    private override init() {
        
    }
}

@objc (GENUserCenterType)
public enum GENUserCenterType : Int{
    
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

extension GENUserCenterType {
    
    static var types: [GENUserCenterType] {
        
        if GENSign.fetchPType() == .lock {
            
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

struct GENUserCenterViewModel: GENViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<GENUserCenterBean>
        
        let itemSelect: ControlEvent<IndexPath>
    }
    
    struct WLOutput {
        
        let zip: Observable<(GENUserCenterBean,IndexPath)>
        
        let tableData: BehaviorRelay<[GENUserCenterBean]> = BehaviorRelay<[GENUserCenterBean]>(value: [])
        
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
        
        self.output.tableData.accept(GENUserCenterBean.createUserCenterTypes())
    }
}

