//
//  FBUserCenterBridge.swift
//  FBBridge
//
//  Created by 王磊 on 2020/3/30.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import FBCollection
import RxDataSources
import FBCocoa
import FBCache
import RxCocoa
import RxSwift
import FBBean
import RxGesture

@objc(FBUserCenterActionType)
public enum FBUserCenterActionType: Int ,Codable {
    
    case header
    
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
    
    case unLogin
    
    case feedBack
    
    case share
    
    case service
    
    case version
    
    case car
}

public typealias FBUserCenterAction = (_ action: FBUserCenterActionType ) -> ()

private var key: Void?

extension FBCollectionHeaderView {
    
    @objc public var user: FBUserBean? {
        get {
            return objc_getAssociatedObject(self, &key) as? FBUserBean
        }
        set{
            objc_setAssociatedObject(self, &key,newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension Reactive where Base: FBCollectionHeaderView {
    
    var user: Binder<FBUserBean?> {
        
        return Binder(base) { view, user in
            
            view.user = user
        }
    }
}

@objc (FBUserCenterBridge)
public final class FBUserCenterBridge: FBBaseBridge {
    
    typealias Section = FBSectionModel<(), FBUserCenterBean>
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
    
    var viewModel: FBUserCenterViewModel!
    
    weak var vc: FBCollectionNoLoadingViewController!
    
    @objc public var headerView: FBCollectionHeaderView!
}

extension FBUserCenterBridge {
    
    @objc public func createUserCenter(_ vc: FBCollectionNoLoadingViewController,centerAction:@escaping FBUserCenterAction) {
        
        self.vc = vc
        
        let input = FBUserCenterViewModel.WLInput(modelSelect: vc.collectionView.rx.modelSelected(FBUserCenterBean.self),
                                                  itemSelect: vc.collectionView.rx.itemSelected)
        
        viewModel = FBUserCenterViewModel(input, disposed: disposed)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { ds, cv, ip, item in return vc.configCollectionViewCell(item, for: ip)},
            configureSupplementaryView: { ds, cv, kind, ip in return vc.configCollectionViewHeader(FBUserInfoCache.default.userBean, for: ip)})
        
        viewModel
            .output
            .tableData
            .asDriver()
            .map({ [Section(model: (), items: $0)]  })
            .drive(vc.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposed)
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .zip
            .subscribe(onNext: {(type,ip) in
                
                vc.collectionView.deselectItem(at: ip, animated: true)
                
                let isLogin = FBAccountCache.default.isLogin()
                
                switch type.type {
                case .setting: centerAction(.setting)
                    
                case .privacy: centerAction(.privacy)
                case .about: centerAction(.about)
                    
                case .userInfo: centerAction(isLogin ? .userInfo : .unLogin)
                case .address: centerAction(isLogin ? .address : .unLogin)
                case .order: centerAction(isLogin ? .order : .unLogin)
                case .focus: centerAction(isLogin ? .focus : .unLogin)
                case .characters: centerAction(isLogin ? .characters : .unLogin)
                case .myCircle: centerAction(isLogin ? .myCircle : .unLogin)
                case .feedBack: centerAction(.feedBack)
                case .service: centerAction(.service)
                case .header: centerAction(isLogin ? .header : .unLogin)
                case .car: centerAction(isLogin ? .car : .unLogin)
                case .share: centerAction(.share)
                case .version: centerAction(.version)
                case .contactUS: centerAction(.contactUS)
                    
                    
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
    }
    
    @objc public func bindUserView(_ headerView: FBCollectionHeaderView,centerAction:@escaping FBUserCenterAction) {
        
        self.headerView = headerView
        
        viewModel
            .output
            .userInfo
            .bind(to: headerView.rx.user)
            .disposed(by: disposed)
        
        headerView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { (_) in
                
                let isLogin = FBAccountCache.default.isLogin()
                
                centerAction(isLogin ? .header : .unLogin)
                
            })
            .disposed(by: disposed)
    }
}
