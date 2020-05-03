//
//  FBUserInfoViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import FBResult
import FBCache
import FBApi
import FBRReq
import FBBean
import FBError
import FBObservableMapper


@objc public final class FBUserInfoBean: NSObject {
    
    @objc public var type: FBUserInfoType = .header
    
    @objc public var img: UIImage!
    
    @objc public var subtitle: String = ""
    
    @objc public var title: String {
        
        return type.title
    }
    
    static func createUserInfo(_ type: FBUserInfoType) -> FBUserInfoBean {
        
        let userInfo = FBUserInfoBean()
        
        userInfo.type = type
        
        return userInfo
    }
    
    static func createUserInfoTypes(_ hasSpace: Bool) -> [FBUserInfoBean] {
        
        var result: [FBUserInfoBean] = []
        
        if hasSpace {
            
            for item in FBUserInfoType.spaceTypes {
                
                result += [FBUserInfoBean.createUserInfo(item)]
            }
            
        } else {
            
            for item in FBUserInfoType.types {
                
                result += [FBUserInfoBean.createUserInfo(item)]
            }
        }
        
        return result
    }
}

@objc (FBUserInfoType)
public enum FBUserInfoType: Int {
    
    case header
    
    case name
    
    case phone
    
    case sex
    
    case signature
    
    case birth
    
    case space
}


extension FBUserInfoType {
    
    static var spaceTypes: [FBUserInfoType] {
        
        return [.space ,.header ,.name ,.phone ,.space ,.sex ,.birth ,.signature]
    }
    static var types: [FBUserInfoType] {
        
        return [.header ,.name ,.phone ,.sex ,.birth ,.signature]
    }
    
    var title: String {
        
        switch self {
            
        case .header: return "头像"
            
        case .name: return "昵称"
            
        case .phone: return "手机号"
            
        case .sex: return "性别"
            
        case .signature: return "个性签名"
            
        case .birth: return "生日"
            
        case .space: return ""
            
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .space: return 10
            
        case .header: return 80
            
        default: return 55
            
        }
    }
    
    var updateKey: String {
        
        switch self {
        case .name: return "users.nickname"
            
        case .birth: return "users.birthday"
            
        case .signature: return "users.signature"
            
        case .sex: return "users.sex"
            
        case .header: return "users.headImg"
        default: return ""
            
        }
    }
}

public struct FBUserInfoViewModel: FBViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        
        let modelSelect: ControlEvent<FBUserInfoBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let hasSpace: Bool
    }
    public struct WLOutput {
        
        let zip: Observable<(FBUserInfoBean,IndexPath)>
        
        let tableData: BehaviorRelay<[FBUserInfoBean]> = BehaviorRelay<[FBUserInfoBean]>(value: [])
    }
    public init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let output = WLOutput(zip: zip)
        
        output.tableData.accept(FBUserInfoBean.createUserInfoTypes(input.hasSpace))
        
        FBUserInfoCache.default
            .rx
            .observe(FBUserBean.self, "userBean")
            .subscribe(onNext: { (user) in
                
                if let user = user {
                    
                    let values =  output.tableData.value
                    
                    if let headIdx = values.firstIndex(where: { $0.type == .header}) {
                        
                        output.tableData.value[headIdx].subtitle = user.headImg
                    }
                    if let nameIdx = values.firstIndex(where: { $0.type == .name}) {
                        
                        output.tableData.value[nameIdx].subtitle = user.nickname
                    }
                    if let phoneIdx = values.firstIndex(where: { $0.type == .phone}) {
                        
                        output.tableData.value[phoneIdx].subtitle = user.phone
                    }
                    if let sexIdx = values.firstIndex(where: { $0.type == .sex}) {
                        
                        output.tableData.value[sexIdx].subtitle = user.gender.gender
                    }
                    
                    if let birthIdx = values.firstIndex(where: { $0.type == .birth}) {
                        
                        output.tableData.value[birthIdx].subtitle = user.birthday
                    }
                    if let signtureIdx = values.firstIndex(where: { $0.type == .signature}) {
                        
                        output.tableData.value[signtureIdx].subtitle = user.signature
                    }
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
    
    public static func updateUserInfo(type: FBUserInfoType,value: String) -> Driver<FBResult>{
        
        return FBDictResp(FBApi.updateUserInfo(type.updateKey, value: value))
            .mapObject(type: FBUserBean.self)
            .map({ FBUserInfoCache.default.saveUser(data: $0) })
            .map { _ in FBResult.ok("")}
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
    
    public static func fetchAliToken() -> Driver<FBResult> {
        
        return FBAliResp(FBApi.aliToken)
            .map { FBResult.fetchSomeObject($0 as AnyObject)}
            .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
    }
}
