//
//  FBSettingBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBTable
import RxDataSources
import FBCocoa
import FBCache

@objc(FBSettingActionType)
public enum FBSettingActionType: Int ,Codable {
    
    case gotoFindPassword = 0
    
    case gotoModifyPassword = 1
    
    case logout = 2
    
    case unlogin = 3
    
    case black = 4
}

public typealias FBSettingAction = (_ action: FBSettingActionType ) -> ()

@objc (FBSettingBridge)
public final class FBSettingBridge: FBBaseBridge {
    
    typealias Section = FBSectionModel<(), FBSettingBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var viewModel: FBSettingViewModel!
    
    weak var vc: FBTableNoLoadingViewController!
}
extension FBSettingBridge {
    
    @objc public func createSetting(_ vc: FBTableNoLoadingViewController ,hasSpace: Bool,settingAction: @escaping FBSettingAction) {
        
        self.vc = vc
        
        let input = FBSettingViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(FBSettingBean.self),
                                                itemSelect: vc.tableView.rx.itemSelected, hasSpace: hasSpace)
        
        viewModel = FBSettingViewModel(input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { ds, tv, ip, item in  return vc.configTableViewCell(item, for: ip) })
        
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
                
                switch type.type {
                    
                case .pwd:
                    
                    settingAction(.gotoFindPassword)
                case .password:
                    
                    settingAction(.gotoModifyPassword)
                    
                case .logout:
                    settingAction(.logout)
                    
                case .black:
                    
                    if FBAccountCache.default.isLogin() {
                        
                        settingAction(.black)
                        
                    } else {
                        
                        settingAction(.unlogin)
                        
                    }
                    
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
    }
    
    @objc public func updateCache(_ value: String ) {
        
        let values = viewModel.output.tableData.value
        
        if let idx = values.firstIndex(where: { $0.type == .clear}) {
            
            viewModel.output.tableData.value[idx].subTitle = value
            
            vc.tableView.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .none)
        }
    }
    
    @objc public func updateTableData(_ hasPlace: Bool) {
        
        viewModel.output.tableData.accept(FBSettingBean.createTabledata(hasPlace))
    }
}
extension FBSettingBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return datasource[indexPath].type.cellHeight
    }
}
