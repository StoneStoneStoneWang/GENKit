//
//  GENUserInfoBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/8/28.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENTable
import GENHud
import GENBean
import RxCocoa
import GENCache
import RxSwift
import RxDataSources
import GENCocoa
import GENRReq
import GENUpload

public typealias GENUserInfoAction = () -> ()

@objc (GENUserInfoBridge)
public final class GENUserInfoBridge: GENBaseBridge {
    
    typealias Section = GENSectionModel<(), GENUserInfoBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var viewModel: GENUserInfoViewModel!
    
    weak var vc: GENTableNoLoadingViewController!
}

extension GENUserInfoBridge {
    
    @objc public func createUserInfo(_ vc: GENTableNoLoadingViewController ,hasSpace: Bool) {
        
        self.vc = vc
        
        let input = GENUserInfoViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(GENUserInfoBean.self),
                                                 itemSelect: vc.tableView.rx.itemSelected,
                                                 hasSpace: hasSpace)
        
        viewModel = GENUserInfoViewModel(input, disposed: disposed)
        
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
    
    @objc public func updateUserInfo(_ type: GENUserInfoType,value: String ) {
        
        let values =  viewModel.output.tableData.value
        
        if let idx = values.firstIndex(where: { $0.type == type}) {
            
            self.vc.tableView.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .fade)
        }
    }
    
    @objc public func updateUserInfo(type: GENUserInfoType,value: String,action: @escaping GENUserInfoAction) {
        
        GENHud.show(withStatus: "修改\(type.title)中...")
        
        GENUserInfoViewModel
            .updateUserInfo(type: type, value: value)
            .drive(onNext: { (result) in
                
                GENHud.pop()
                switch result {
                    
                case .ok(_):
                    
                    action()
                    
                    GENHud.showInfo(type == .header ? "上传头像成功" : "修改\(type.title)成功")
                    
                case .failed(let msg): GENHud.showInfo(msg)
                default: break
                }
            })
            .disposed(by: disposed)
    }
    @objc public func updateHeader(_ data: Data ,action: @escaping GENUserInfoAction) {
        
        GENHud.show(withStatus: "上传头像中...")
        
        GENUserInfoViewModel
            .fetchAliToken()
            .drive(onNext: { (result) in
                
                switch result {
                case .fetchSomeObject(let obj):
                    
                    DispatchQueue.global().async {
                        
                        GENUploadImgResp(data, file: "headerImg", param: obj as! GENCredentialsBean)
                            .subscribe(onNext: { [weak self] (value) in
                                
                                guard let `self` = self else { return }
                                
                                DispatchQueue.main.async {
                                    
                                    self.updateUserInfo(type: GENUserInfoType.header, value: value, action: action)
                                }
                                
                                }, onError: { (error) in
                                    
                                    GENHud.pop()
                                    
                                    GENHud.showInfo("上传头像失败")
                            })
                            .disposed(by: self.disposed)
                    }
                    
                case let .failed(msg):
                    
                    GENHud.pop()
                    
                    GENHud.showInfo(msg)
                    
                default: break
                    
                }
            })
            .disposed(by: disposed)
    }
}
extension GENUserInfoBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return datasource[indexPath].type.cellHeight
    }
}
