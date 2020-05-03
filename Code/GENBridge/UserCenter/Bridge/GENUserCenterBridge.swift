//
//  GENUserCenterBridge.swift
//  GENBridge
//
//  Created by 王磊 on 2020/3/30.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import GENCollection
import RxDataSources
import GENCocoa
import GENCache
import RxCocoa
import RxSwift
import GENBean
import RxGesture

@objc(GENUserCenterActionType)
public enum GENUserCenterActionType: Int ,Codable {
    
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

public typealias GENUserCenterAction = (_ action: GENUserCenterActionType ) -> ()

private var key: Void?

extension GENCollectionHeaderView {
    
    @objc public var user: GENUserBean? {
        get {
            return objc_getAssociatedObject(self, &key) as? GENUserBean
        }
        set{
            objc_setAssociatedObject(self, &key,newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension Reactive where Base: GENCollectionHeaderView {
    
    var user: Binder<GENUserBean?> {
        
        return Binder(base) { view, user in
            
            view.user = user
        }
    }
}

@objc (GENUserCenterBridge)
public final class GENUserCenterBridge: GENBaseBridge {
    
    typealias Section = GENSectionModel<(), GENUserCenterBean>
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
    
    var viewModel: GENUserCenterViewModel!
    
    weak var vc: GENCollectionNoLoadingViewController!
    
    @objc public var headerView: GENCollectionHeaderView!
}

extension GENUserCenterBridge {
    
    @objc public func createUserCenter(_ vc: GENCollectionNoLoadingViewController,centerAction:@escaping GENUserCenterAction) {
        
        self.vc = vc
        
        let input = GENUserCenterViewModel.WLInput(modelSelect: vc.collectionView.rx.modelSelected(GENUserCenterBean.self),
                                                  itemSelect: vc.collectionView.rx.itemSelected)
        
        viewModel = GENUserCenterViewModel(input, disposed: disposed)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { ds, cv, ip, item in return vc.configCollectionViewCell(item, for: ip)},
            configureSupplementaryView: { ds, cv, kind, ip in return vc.configCollectionViewHeader(GENUserInfoCache.default.userBean, for: ip)})
        
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
                
                let isLogin = GENAccountCache.default.isLogin()
                
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
    
    @objc public func bindUserView(_ headerView: GENCollectionHeaderView,centerAction:@escaping GENUserCenterAction) {
        
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
                
                let isLogin = GENAccountCache.default.isLogin()
                
                centerAction(isLogin ? .header : .unLogin)
                
            })
            .disposed(by: disposed)
    }
}
