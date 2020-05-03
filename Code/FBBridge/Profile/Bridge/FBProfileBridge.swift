//
//  FBProfileBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/27.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBTable
import RxDataSources
import FBCocoa
import FBCache
import RxCocoa
import RxSwift
import FBBean
import RxGesture

@objc(FBProfileActionType)
public enum FBProfileActionType: Int ,Codable {
    
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
    
    case favor
}

public typealias FBProfileAction = (_ action: FBProfileActionType ) -> ()

private var key: Void?

extension FBTableHeaderView {
    
    @objc public var user: FBUserBean? {
        get {
            return objc_getAssociatedObject(self, &key) as? FBUserBean
        }
        set{
            objc_setAssociatedObject(self, &key,newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension Reactive where Base: FBTableHeaderView {
    
    var user: Binder<FBUserBean?> {
        
        return Binder(base) { view, user in
            
            view.user = user
        }
    }
}

@objc (FBProfileBridge)
public final class FBProfileBridge: FBBaseBridge {
    
    typealias Section = FBSectionModel<(), FBProfileBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var viewModel: FBProfileViewModel!
    
    weak var vc: FBTableNoLoadingViewController!
}

extension FBProfileBridge {
    
    @objc public func createProfile(_ vc: FBTableNoLoadingViewController,hasSpace: Bool,profileAction:@escaping FBProfileAction) {
        
        let input = FBProfileViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(FBProfileBean.self),
                                              itemSelect: vc.tableView.rx.itemSelected,
                                              hasSpace: hasSpace)
        
        viewModel = FBProfileViewModel(input, disposed: disposed)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { ds, tv, ip, item in return vc.configTableViewCell(item, for: ip)  })
        
        viewModel
            .output
            .tableData
            .asDriver()
            .map({ [Section(model: (), items: $0)]  })
            .drive(vc.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposed)
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .userInfo
            .bind(to: vc.headerView.rx.user)
            .disposed(by: disposed)
        
        viewModel
            .output
            .zip
            .subscribe(onNext: {(type,ip) in
                
                vc.tableView.deselectRow(at: ip, animated: true)
                
                let isLogin = FBAccountCache.default.isLogin()
                
                switch type.type {
                case .setting: profileAction(.setting)
                    
                case .privacy: profileAction(.privacy)
                case .about: profileAction(.about)
                    
                case .userInfo: profileAction(isLogin ? .userInfo : .unLogin)
                case .address: profileAction(isLogin ? .address : .unLogin)
                case .order: profileAction(isLogin ? .order : .unLogin)
                case .focus: profileAction(isLogin ? .focus : .unLogin)
                case .characters: profileAction(isLogin ? .characters : .unLogin)
                case .myCircle: profileAction(isLogin ? .myCircle : .unLogin)
                case .feedBack: profileAction(.feedBack)
                case .favor: profileAction(isLogin ? .favor : .unLogin)
                case .contactUS:
                    
                    vc.tableViewSelectData(type, for: ip)
                    
                default:
                    break
                }
            })
            .disposed(by: disposed)
        vc
            .tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposed)
        
        vc
            .headerView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { (_) in
                
                let isLogin = FBAccountCache.default.isLogin()
                
                profileAction(isLogin ? .header : .unLogin)
            
            })
            .disposed(by: disposed)
    }
}

extension FBProfileBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return datasource[indexPath].type.cellHeight
    }
}
