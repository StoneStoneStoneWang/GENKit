//
//  FBAboutViewModel.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/27.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBViewModel
import RxCocoa
import RxSwift
import WLToolsKit

@objc public final class FBAboutBean: NSObject {
    
    @objc public var type: FBAboutType = .space
    
    @objc public var title: String = ""
    
    @objc public var subTitle: String = ""
    
    @objc public static func createAbout(_ type: FBAboutType ,title: String ,subTitle: String) -> FBAboutBean {
        
        let about = FBAboutBean()
        
        about.type = type
        
        about.title = title
        
        about.subTitle = subTitle
        
        return about
    }
    private override init() { }
}

@objc (FBAboutType)
public enum FBAboutType: Int {
    
    case version
    
    case email
    
    case wechat
    
    case space
    
    case check
}

extension FBAboutType {
    
    static var types: [FBAboutType] {
        
        return [.version,.email,.wechat,.check]
    }
    
    static var spaceTypes: [FBAboutType] {
        
        return [.space,.email,.wechat]
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .space: return 10
            
        default: return 55
            
        }
    }
    
    var title: String {
        
        switch self {
            
        case .version: return "版本号"
            
        case .email: return "官方邮箱"
            
        case .wechat: return "官方公众号"
            
        case .check: return "检查更新"
            
        case .space: return ""
        }
    }
    
    var subtitle: String {
        
        switch self {
            
        case .version: return "当前版本: \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)"
            
        case .email:
            
            guard let info = Bundle.main.infoDictionary else { return "" }
            
            return (info["CFBundleDisplayName"] as? String ?? "").transformToPinYin() + "@gmail.com"
            
        case .wechat:
            
            guard let info = Bundle.main.infoDictionary else { return "" }

            return info["CFBundleDisplayName"] as? String ?? ""
            
        case .check: return ""
        case .space: return ""
        }
    }
}

struct FBAboutViewModel: FBViewModel {
    
    var input: WLInput
    
    var output: WLOutput
    
    struct WLInput {
        
        let modelSelect: ControlEvent<FBAboutType>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let hasSpace: Bool
    }
    struct WLOutput {
        
        let zip: Observable<(FBAboutType,IndexPath)>
        
        let tableData: BehaviorRelay<[FBAboutType]> = BehaviorRelay<[FBAboutType]>(value: [])
    }
    init(_ input: WLInput) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        self.output = WLOutput(zip: zip)
        
        self.output.tableData.accept(input.hasSpace ? FBAboutType.spaceTypes : FBAboutType.types)
    }
}
