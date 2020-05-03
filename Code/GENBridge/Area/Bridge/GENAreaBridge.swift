//
//  GENAreaBridge.swift
//  ZBridge
//
//  Created by three stone 王 on 2020/3/13.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENCocoa
import RxDataSources
import GENTable
import GENBean

@objc (GENAreaType)
public enum GENAreaType: Int {
    
    case province
    
    case city
    
    case region
}

public typealias GENAreaAction = (_ selectedArea: GENAreaBean ,_ type: GENAreaType ,_ hasNext: Bool) -> ()

@objc (GENAreaBridge)
public final class GENAreaBridge: GENBaseBridge {
    
    var viewModel: GENAreaViewModel!
    
    typealias Section = GENSectionModel<(), GENAreaBean>
    
    var dataSource: RxTableViewSectionedReloadDataSource<Section>!
    
    var type: GENAreaType = .province
    
    var areas: [GENAreaBean] = []
    
    var selectedArea: GENAreaBean!
}

extension GENAreaBridge {
    
    @objc public func createArea(_ vc: GENTableNoLoadingViewController ,type: GENAreaType,areaAction: @escaping GENAreaAction) {
        
        self.type = type
        
        let input = GENAreaViewModel.WLInput(areas: areas,
                                             modelSelect: vc.tableView.rx.modelSelected(GENAreaBean.self),
                                             itemSelect: vc.tableView.rx.itemSelected)
        
        viewModel = GENAreaViewModel(input, disposed: disposed)
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { ds, tv, ip, item in return vc.configTableViewCell(item, for: ip)})
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .tableData
            .asDriver()
            .map({ [Section(model: (), items: $0)]  })
            .drive(vc.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposed)
        
        viewModel
            .output
            .zip
            .subscribe(onNext: { [unowned self](area,ip) in
                
                vc.tableView.deselectRow(at: ip, animated: true)
                
                let values = self.viewModel.output.tableData.value
                
                _ = values.map({ $0.isSelected = false })
                
                area.isSelected = true
                
                self.viewModel.output.tableData.accept(values)
                
                switch type {
                case .province: fallthrough
                case .region:
                    areaAction(area,type, true)
                case .city:
                    
                    areaAction(area,type, self.fetchRegions(area.areaId).count > 0)
                default:
                    break;
                }
            })
            .disposed(by: disposed)
        vc
            .tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposed)
        
        GENAreaManager
            .default
            .fetchAreas()
            .drive(onNext: { [unowned self ](result) in
                
                switch result {
                case .fetchList(let list):
                    
                    var mutable: [GENAreaBean] = []
                    
                    switch type {
                    case .province:
                        
                        mutable += self.fetchProvices(list as! [GENAreaBean])
                    case .city:
                        
                        //                        mutable += self.fetchCitys(<#T##id: Int##Int#>)
                        break
                    case .region:
                        break
                        
                    }
                    
                    self.viewModel.output.tableData.accept(mutable)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
    
    @objc public func fetchAreas() {
        
        GENAreaManager
            .default
            .fetchAreas()
            .drive(onNext: { (result) in
                
                
            })
            .disposed(by: disposed)
    }
    
    @objc public func updateDatas(_ id: Int ,areas: [GENAreaBean]) {
        
        switch type {
        case .city:
            
            self.viewModel.output.tableData.accept(self.fetchCitys(id))
            
        case .region:
            
            self.viewModel.output.tableData.accept(self.fetchRegions(id))
        case .province:
            
            self.viewModel.output.tableData.accept(self.fetchProvices(areas))
        }
    }
    @objc public func fetchProvice(pName: String) -> GENAreaBean {
        
        let values = self.viewModel.output.tableData.value
        
        let idx = values.firstIndex(where: {  $0.name == pName })!
        
        return values[idx]
        
    }
    
    @objc public func fetchArea(id: Int) -> GENAreaBean {
        
        return GENAreaManager.default.fetchSomeArea(id)
        
    }
    @objc public func fetchIp(id: Int) -> IndexPath {
        
        let values = self.viewModel.output.tableData.value
        
        let idx = values.firstIndex(where: {  $0.areaId == id })!
        
        return IndexPath(row: idx, section: 0)
    }
    @objc public func fetchProvices(_ areas: [GENAreaBean]) -> [GENAreaBean] {
        
        var result: [GENAreaBean] = []
        
        for item in areas {
            
            if item.arealevel == 1 {
                
                result += [item]
            }
        }
        return result
    }
    
    @objc public func fetchCitys(_ id: Int) -> [GENAreaBean] {
        
        var result: [GENAreaBean] = []
        
        for item in GENAreaManager.default.allAreas {
            
            if item.arealevel == 2 {
                
                if item.pid == id {
                    
                    result += [item]
                }
            }
        }
        return result
    }
    
    @objc public func fetchRegions(_ id: Int) -> [GENAreaBean] {
        
        var result: [GENAreaBean] = []
        
        for item in GENAreaManager.default.allAreas {
            
            if item.arealevel == 3 {
                
                if item.pid == id {
                    
                    result += [item]
                }
            }
        }
        return result
    }
}

extension GENAreaBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}
