//
//  FBUserInfoBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBTable
import FBHud
import FBBean
import RxCocoa
import FBCache
import RxSwift
import RxDataSources
import FBCocoa
import FBRReq
import FBUpload

public typealias FBUserInfoAction = () -> ()

@objc (FBUserInfoBridge)
public final class FBUserInfoBridge: FBBaseBridge {
    
    typealias Section = FBSectionModel<(), FBUserInfoBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var viewModel: FBUserInfoViewModel!
    
    weak var vc: FBTableNoLoadingViewController!
}

extension FBUserInfoBridge {
    
    @objc public func createUserInfo(_ vc: FBTableNoLoadingViewController ,hasSpace: Bool) {
        
        self.vc = vc
        
        let input = FBUserInfoViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(FBUserInfoBean.self),
                                                 itemSelect: vc.tableView.rx.itemSelected,
                                                 hasSpace: hasSpace)
        
        viewModel = FBUserInfoViewModel(input, disposed: disposed)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { ds, tv, ip, item in return vc.configTableViewCell(item, for: ip)})
        
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
            .zip
            .subscribe(onNext: { (type,ip) in
                
                vc.tableView.deselectRow(at: ip, animated: true)
                
                vc.tableViewSelectData(type, for: ip)
            })
            .disposed(by: disposed)
        vc
            .tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposed)
    }
    
    @objc public func updateUserInfo(_ type: FBUserInfoType,value: String ) {
        
        let values =  viewModel.output.tableData.value
        
        if let idx = values.firstIndex(where: { $0.type == type}) {
            
            self.vc.tableView.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .fade)
        }
    }
    
    @objc public func updateUserInfo(type: FBUserInfoType,value: String,action: @escaping FBUserInfoAction) {
        
        FBHud.show(withStatus: "修改\(type.title)中...")
        
        FBUserInfoViewModel
            .updateUserInfo(type: type, value: value)
            .drive(onNext: { (result) in
                
                FBHud.pop()
                switch result {
                    
                case .ok(_):
                    
                    action()
                    
                    FBHud.showInfo(type == .header ? "上传头像成功" : "修改\(type.title)成功")
                    
                case .failed(let msg): FBHud.showInfo(msg)
                default: break
                }
            })
            .disposed(by: disposed)
    }
    @objc public func updateHeader(_ data: Data ,action: @escaping FBUserInfoAction) {
        
        FBHud.show(withStatus: "上传头像中...")
        
        FBUserInfoViewModel
            .fetchAliToken()
            .drive(onNext: { (result) in
                
                switch result {
                case .fetchSomeObject(let obj):
                    
                    DispatchQueue.global().async {
                        
                        FBUploadImgResp(data, file: "headerImg", param: obj as! FBALCredentialsBean)
                            .subscribe(onNext: { [weak self] (value) in
                                
                                guard let `self` = self else { return }
                                
                                DispatchQueue.main.async {
                                    
                                    self.updateUserInfo(type: FBUserInfoType.header, value: value, action: action)
                                }
                                
                                }, onError: { (error) in
                                    
                                    FBHud.pop()
                                    
                                    FBHud.showInfo("上传头像失败")
                            })
                            .disposed(by: self.disposed)
                    }
                    
                case let .failed(msg):
                    
                    FBHud.pop()
                    
                    FBHud.showInfo(msg)
                    
                default: break
                    
                }
            })
            .disposed(by: disposed)
    }
}
extension FBUserInfoBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return datasource[indexPath].type.cellHeight
    }
}
