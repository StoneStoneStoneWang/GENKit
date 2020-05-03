//
//  FBCollectionsBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/8/29.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBCollection
import RxDataSources
import FBCocoa
import FBBean
import FBHud
import FBCache

@objc(FBCollectionsActionType)
public enum FBCollectionsActionType: Int ,Codable {
    
    case myCircle = 0
    
    case circle = 1
    
    case comment = 2
    
    case watch = 3
    
    case report = 4
    
    case unLogin = 5
    
    case like = 6
    
    case focus = 7
    
    case black = 8
    
    case remove = 9
    
    case share = 10
}

public typealias FBCollectionsAction = (_ actionType: FBCollectionsActionType ,_ circle: FBCircleBean? ,_ ip: IndexPath?) -> ()

@objc (FBCollectionsBridge)
public final class FBCollectionsBridge: FBBaseBridge {
    
    typealias Section = FBAnimationSetionModel<FBCircleBean>
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<Section>!
    
    public var viewModel: FBCollectionsViewModel!
    
    weak var vc: FBCollectionLoadingViewController!
    
    var moreSection: Bool = false
}

extension FBCollectionsBridge {
    
    @objc public func createCollections(_ vc: FBCollectionLoadingViewController ,moreSection: Bool,isMy: Bool ,tag: String ,collectionsAction: @escaping FBCollectionsAction) {
        
        self.vc = vc
        
        self.moreSection = moreSection
        
        let input = FBCollectionsViewModel.WLInput(isMy: isMy,
                                                   modelSelect: vc.collectionView.rx.modelSelected(FBCircleBean.self),
                                                   itemSelect: vc.collectionView.rx.itemSelected,
                                                   headerRefresh: vc.collectionView.mj_header!.rx.FBRefreshing.asDriver(),
                                                   footerRefresh: vc.collectionView.mj_footer!.rx.FBRefreshing.asDriver(),
                                                   tag: tag)
        
        viewModel = FBCollectionsViewModel(input, disposed: disposed)
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .left),
            decideViewTransition: { _,_,_  in return .reload },
            configureCell: { ds, tv, ip, item in return vc.configCollectionViewCell(item, for: ip) })
        
        if moreSection {
            
            viewModel
                .output
                .collectionData
                .asDriver()
                .map({ $0.map({ Section(header: $0.encoded, items: [$0]) }) })
                .drive(vc.collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposed)
        } else {
            
            viewModel
                .output
                .collectionData
                .map({ [Section(header: "", items: $0)] })
                .bind(to: vc.collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposed)
        }
        
        let endHeaderRefreshing = viewModel.output.endHeaderRefreshing
        
        endHeaderRefreshing
            .map({ _ in return true })
            .drive(vc.collectionView.mj_header!.rx.FBEndRefreshing)
            .disposed(by: disposed)
        
        endHeaderRefreshing
            .drive(onNext: { (res) in
                switch res {
                case .fetchList:
                    vc.loadingStatus = .succ
                case let .failed(msg):
                    FBHud.showInfo(msg)
                    vc.loadingStatus = .fail
                    
                case .empty:
                    vc.loadingStatus = .succ
                    
                    vc.collectionEmptyShow()
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
        let endFooterRefreshing = viewModel.output.endFooterRefreshing
        
        endFooterRefreshing
            .map({ _ in return true })
            .drive(vc.collectionView.mj_footer!.rx.FBEndRefreshing)
            .disposed(by: disposed)
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .zip
            .subscribe(onNext: { (circle,ip) in
                
                collectionsAction(isMy ? .myCircle : .circle, circle, ip)
            })
            .disposed(by: disposed)
        
        viewModel
            .output
            .footerHidden
            .bind(to: vc.collectionView.mj_footer!.rx.isHidden)
            .disposed(by: disposed)
    }
}

extension FBCollectionsBridge {
    
    @objc public func updateCircle(_ circle: FBCircleBean ,forIp ip: IndexPath) {
        
        var values = viewModel.output.collectionData.value
        
        if moreSection {
            
            values.replaceSubrange(ip.section..<ip.section+1, with: [circle])
        } else {
            
            values.replaceSubrange(ip.row..<ip.row+1, with: [circle])
        }
        
        viewModel.output.collectionData.accept(values)
        
        vc.collectionView.reloadItems(at: [ip])
    }
    
    @objc public func insertCircle(_ circle: FBCircleBean) {
        
        var values = viewModel.output.collectionData.value
        
        values.insert(circle, at: 0)
        
        if values.count == 1 {
            
            vc.collectionEmptyHidden()
        }
        
        viewModel.output.collectionData.accept(values)
    }
    
    @objc public func fetchCircle(_ ip: IndexPath) -> FBCircleBean? {
        
        guard let dataSource = dataSource else { return nil }
        
        return dataSource[ip]
    }
    
    @objc public func fetchIp(_ circle: FBCircleBean) -> IndexPath {
        
        let values = viewModel.output.collectionData.value
        
        if let idx = values.firstIndex(where: { $0.encoded == circle.encoded }) {
            
            if moreSection {
                
                return IndexPath(item: 0, section: idx)
            } else {
                
                return IndexPath(item: idx, section: 0)
            }
        
        }
        return IndexPath(item: 0, section: 0)
        
    }
    @objc public func converToJson(_ circle: FBCircleBean) -> [String: Any] {
        
        return circle.toJSON()
    }
    
    @objc public func deleteIp(_ ip: IndexPath,moreSection: Bool) {
        
        var values = self.viewModel.output.collectionData.value
        
        if moreSection {
            
            values.remove(at: ip.section)
        } else {
            
            values.remove(at: ip.row)
        }
        
        self.viewModel.output.collectionData.accept(values)
        
        if values.isEmpty {
            
            self.vc.collectionEmptyShow()
        }
    }
    
    @objc public func addBlack(_ OUsEncoded: String,targetEncoded: String ,content: String ,collectionsAction: @escaping FBCollectionsAction ) {
        
        if !FBAccountCache.default.isLogin() {
            
            collectionsAction(.unLogin, nil,nil)
            
            return
        }
        
        FBHud.show(withStatus: "添加黑名单中...")
        
        FBCollectionsViewModel
            .addBlack(OUsEncoded, targetEncoded: targetEncoded, content: content)
            .drive(onNext: { (result) in
                
                FBHud.pop()
                
                switch result {
                case .ok(let msg):
                    
                    self.vc.collectionView.mj_header!.beginRefreshing()
                    
                    collectionsAction(.black, nil, nil)
                    
                    FBHud.showInfo(msg)
                case .failed(let msg):
                    
                    FBHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
    
    @objc public func focus(_ uid: String ,encode: String ,isFocus: Bool ,collectionsAction: @escaping FBCollectionsAction ) {
        
        if !FBAccountCache.default.isLogin() {
            
            collectionsAction(.unLogin, nil,nil)
            
            return
        }
        
        FBHud.show(withStatus: isFocus ? "取消关注中..." : "关注中...")
        
        FBCollectionsViewModel
            .focus(uid, encode: encode)
            .drive(onNext: { (result) in
                
                FBHud.pop()
                
                switch result {
                case .ok(_):
                    
                    let values = self.viewModel.output.collectionData.value
                    
                    if let index = values.firstIndex(where: { $0.encoded == encode }) {
                        
                        let circle = values[index]
                        
                        circle.isattention = !circle.isattention
                        
                        self.viewModel.output.collectionData.accept(values)
                        
                        collectionsAction(.focus, circle,nil)
                    }
                    
                    FBHud.showInfo(isFocus ? "取消关注成功" : "关注成功")
                    
                case .failed(let msg):
                    
                    FBHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
    }
    
    @objc public func operation(_ encoded: String ,isLike: Bool ,status: String ,aMsg: String,collectionsAction: @escaping () -> () ) {
        
        FBHud.show(withStatus: status)
        
        FBCollectionsViewModel
            .like(encoded, isLike: isLike)
            .drive(onNext: { (result) in
                
                FBHud.pop()
                
                switch result {
                case .ok(_):
                    
                    collectionsAction()
                    
                    FBHud.showInfo(aMsg)
                case .failed(let msg):
                    
                    FBHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
    
    @objc public func like(_ encoded: String ,isLike: Bool ,collectionsAction: @escaping FBCollectionsAction) {
        
        if !FBAccountCache.default.isLogin() {
            
            collectionsAction(.unLogin, nil,nil)
            
            return
        }
        
        FBHud.show(withStatus: isLike ? "取消点赞中..." : "点赞中...")
        
        FBCollectionsViewModel
            .like(encoded, isLike: isLike)
            .drive(onNext: { (result) in
                
                FBHud.pop()
                
                switch result {
                case .ok(let msg):
                    
                    let values = self.viewModel.output.collectionData.value
                    
                    if let index = values.firstIndex(where: { $0.encoded == encoded }) {
                        
                        let circle = values[index]
                        
                        circle.isLaud = !circle.isLaud
                        
                        if isLike { circle.countLaud -= 1 }
                        else { circle.countLaud += 1}
                        
                        self.viewModel.output.collectionData.accept(values)
                        
                        collectionsAction(.like, circle,nil)
                    }
                    
                    FBHud.showInfo(msg)
                case .failed(let msg):
                    
                    FBHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
    
    @objc public func removeMyCircle(_ encoded: String ,ip: IndexPath,collectionsAction: @escaping FBCollectionsAction)  {
        
        FBHud.show(withStatus: "移除内容中...")
        
        FBCollectionsViewModel
            .removeMyCircle(encoded)
            
            .drive(onNext: { [weak self] (result) in
                
                guard let `self` = self else { return }
                switch result {
                case .ok:
                    
                    FBHud.pop()
                    
                    FBHud.showInfo("移除当前内容成功")
                    
                    var value = self.viewModel.output.collectionData.value
                    
                    let circle = value[ip.row]
                    
                    value.remove(at: ip.row)
                    
                    self.viewModel.output.collectionData.accept(value)
                    
                    if value.isEmpty {
                        
                        self.vc.collectionEmptyShow()
                    }
                    
                    collectionsAction(.remove, circle, ip)
                case .failed:
                    
                    FBHud.pop()
                    
                    FBHud.showInfo("移除当前内容失败")
                    
                default: break
                    
                }
            })
            .disposed(by: self.disposed)
    }
}
