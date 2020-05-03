//
//  GENAddressEditBridge.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/20.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENTable
import GENHud
import GENBean
import RxCocoa
import RxSwift
import RxDataSources
import GENCocoa

public typealias ZCharactersEditAction = (_ address: GENAddressBean?) -> ()

@objc (GENAddressEditBridge)
public final class GENAddressEditBridge: GENBaseBridge {
    
    typealias Section = GENSectionModel<(), GENAddressEditBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var viewModel: GENAddressEditViewModel!
    
    var vc: GENTableNoLoadingViewController!
    
    let name: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    let phone: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    let detail: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    let def: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    let province: BehaviorRelay<GENAreaBean> = BehaviorRelay<GENAreaBean>(value: GENAreaBean())
    
    let city: BehaviorRelay<GENAreaBean> = BehaviorRelay<GENAreaBean>(value: GENAreaBean())
    
    let region: BehaviorRelay<GENAreaBean> = BehaviorRelay<GENAreaBean>(value: GENAreaBean())
}

extension GENAddressEditBridge {
    
    @objc public func createAddressEdit(_ vc: GENTableNoLoadingViewController,temp: GENAddressBean? ,editAction: @escaping ZCharactersEditAction) {
        
        if let completeItem = vc.navigationItem.rightBarButtonItem?.customView as? UIButton {
            
            self.vc = vc
            
            let input = GENAddressEditViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(GENAddressEditBean.self),
                                                         itemSelect: vc.tableView.rx.itemSelected,
                                                         completeTaps: completeItem.rx.tap.asSignal(),
                                                         encode: temp?.encoded ?? "",
                                                         name: name.asDriver(),
                                                         phone: phone.asDriver(),
                                                         detail: detail.asDriver(),
                                                         province: province.asDriver(),
                                                         city: city.asDriver(),
                                                         region: region.asDriver(),
                                                         def: def.asDriver())
            
            viewModel = GENAddressEditViewModel(input, disposed: disposed)
            
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
            
            
            viewModel
                .output
                .completing
                .drive(onNext: { _ in
                    
                    vc.view.endEditing(true)
                    
                    GENHud.show(withStatus: "编辑地址中")
                    
                })
                .disposed(by: disposed)
            
            // MARK:
            viewModel
                .output
                .completed
                .drive(onNext: {
                    
                    GENHud.pop()
                    
                    switch $0 {
                        
                    case let .failed(msg): GENHud.showInfo(msg)
                        
                    case let .operation(obj):
                        
                        GENHud.showInfo(temp != nil ? "修改地址成功" : "添加地址成功")
                        
                        editAction(obj as? GENAddressBean)
                        
                    default: break
                    }
                })
                .disposed(by: disposed)
            
            let values = viewModel.output.tableData.value
            
            if let temp = temp {
                
                values[0].value = temp.name
                
                name.accept(temp.name)
                
                values[1].value = temp.phone
                
                phone.accept(temp.phone)
                
                values[3].value = temp.addr
                
                detail.accept(temp.addr)
                
                values[4].isDef = temp.isdel
            
                def.accept(temp.isdel)
                
                let p = GENAreaBean()
                
                p.areaId = temp.plcl
                p.name = temp.plclne
                
                let c = GENAreaBean()
                
                c.areaId = temp.city
                c.name = temp.cityne
                
                let r = GENAreaBean()
                
                r.areaId = temp.region
                r.name = temp.regionne
                
                province.accept(p)
                
                values[2].pArea = p
                
                city.accept(c)
                
                values[2].cArea = c
                
                region.accept(r)
                
                values[2].rArea = r
                
                vc.tableView.reloadData()
            }
        }
    }
    
    @objc public func updateAddressEdit(type: GENAddressEditType,value: String) {
        
        let values = viewModel.output.tableData.value

        if let idx = values.firstIndex(where: { $0.type == type }) {

            let edit = values[idx]

            edit.value = value

            if type == .name {

                name.accept(value)
            } else if type == .phone {

                phone.accept(value)
            } else if type == .detail {

                detail.accept(value)
            }
        }
    }
    
    @objc public func updateAddressEditDef(isDef: Bool) {
        
        let values = viewModel.output.tableData.value
        
        if let idx = values.firstIndex(where: { $0.type == .def }) {
            
            let edit = values[idx]
            
            edit.isDef = isDef
        
            def.accept(isDef)
            
            vc.tableView.reloadRows(at: [IndexPath(item: idx, section: 0)], with: .fade)
        }
    }
    @objc public func updateAddressEditArea(pid: Int ,pName: String,cid: Int ,cName: String,rid: Int ,rName: String) {
        
        let values = viewModel.output.tableData.value
        
        if let idx = values.firstIndex(where: { $0.type == .area }) {
            
            let edit = values[idx]
            
            let p = GENAreaBean()
            
            p.areaId = pid
            p.name = pName
            
            let c = GENAreaBean()
            
            c.areaId = cid
            c.name = cName
            
            let r = GENAreaBean()
            
            r.areaId = rid
            r.name = rName
            
            province.accept(p)
            
            edit.pArea = p
            
            city.accept(c)
            
            edit.cArea = c
            
            region.accept(r)
            
            edit.rArea = r
            
            vc.tableView.reloadRows(at: [IndexPath(item: idx, section: 0)], with: .fade)
        }
    }
}
extension GENAddressEditBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0 }
        
        return datasource[indexPath].type.cellHeight
    }
}
