//
//  GENCommentBridge.swift
//  GENBridge
//
//  Created by three stone 王 on 2019/9/11.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import GENTable
import RxDataSources
import GENCocoa
import GENBean
import GENHud
import MJRefresh

@objc (GENCommentBridge)
public final class GENCommentBridge: GENBaseBridge {
    
    typealias Section = GENAnimationSetionModel<GENCommentBean>
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<Section>!
    
    var viewModel: GENCommentViewModel!
    
    weak var vc: GENTableLoadingViewController!
    
    var circleBean: GENCircleBean!
}
extension GENCommentBridge {
    
    @objc public func createComment(_ vc: GENTableLoadingViewController,encode: String ,circle: GENCircleBean) {
        
        self.vc = vc
        
        self.circleBean = circle
        
        let input = GENCommentViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(GENCommentBean.self),
                                              itemSelect: vc.tableView.rx.itemSelected,
                                              headerRefresh: vc.tableView.mj_header!.rx.GENRefreshing.asDriver(),
                                              footerRefresh: vc.tableView.mj_footer!.rx.GENRefreshing.asDriver(),
                                              encoded: encode)
        
        viewModel = GENCommentViewModel(input, disposed: disposed)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<Section>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .left),
            decideViewTransition: { _,_,_  in return .reload },
            configureCell: { ds, tv, ip, item in return vc.configTableViewCell(item, for: ip)})
        
        viewModel
            .output
            .tableData
            .asDriver()
            .map({ $0.map({ Section(header: $0.encoded, items: [$0]) }) })
            .drive(vc.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposed)
        
        let endHeaderRefreshing = viewModel.output.endHeaderRefreshing
        
        endHeaderRefreshing
            .map({ _ in return true })
            .drive(vc.tableView.mj_header!.rx.GENEndRefreshing)
            .disposed(by: disposed)
        
        endHeaderRefreshing
            .drive(onNext: { (res) in
                switch res {
                case .fetchList:
                    vc.loadingStatus = .succ
                case let .failed(msg):
                    GENHud.showInfo(msg)
                    vc.loadingStatus = .fail
                    
                case .empty:
                    vc.loadingStatus = .succ
                    
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
        let endFooterRefreshing = viewModel.output.endFooterRefreshing
        
        endFooterRefreshing
            .map({ _ in return true })
            .drive(vc.tableView.mj_footer!.rx.GENEndRefreshing)
            .disposed(by: disposed)
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .zip
            .subscribe(onNext: { (type,ip) in
                
                vc.tableViewSelectData(type, for: ip)
                
            })
            .disposed(by: disposed)
        
        viewModel
            .output
            .footerHidden
            .bind(to: vc.tableView.mj_footer!.rx.isHidden)
            .disposed(by: disposed)
        
        vc
            .tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposed)
    }
    @objc public func insertComment(_ comment: GENCommentBean) {
        
        var value = self.viewModel.output.tableData.value
        
        if value.last!.type == .empty {
            
            value.removeLast()
            
            value.insert(comment, at: 2)
            
            self.viewModel.output.tableData.accept(value)
            
        } else if value.last!.type == .failed {
            
            self.vc.tableView.mj_header!.beginRefreshing()
            
        } else {
            
            value.insert(comment , at: 2)
            
            self.viewModel.output.tableData.accept(value)
        }
        
        self.vc.tableView.scrollsToTop = true

    }
    @objc public func addComment(_ encoded: String,content: String ,commentAction: @escaping (_ comment: GENCommentBean? ,_ circleBean: GENCircleBean) -> () ) {
        
        GENHud.show(withStatus: "发布评论中....")
        
        GENCommentViewModel
            .addComment(encoded, content: content)
            .drive(onNext: { [unowned self](result) in
                
                GENHud.pop()
                
                switch result {
                case .operation(let comment):
                    
                    GENHud.showInfo("发布评论成功!")
                    
                    self.circleBean.countComment += 1
                    
                    self.insertComment(comment as! GENCommentBean)
                    
                    commentAction(comment as? GENCommentBean ,self.circleBean)

                case .failed(let msg):
                    
                    GENHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
}

extension GENCommentBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return vc.caculate(forCell: datasource[indexPath], for: indexPath)
    }
}
