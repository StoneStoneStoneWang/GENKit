//
//  FBCommentBridge.swift
//  FBBridge
//
//  Created by three stone 王 on 2019/9/11.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBTable
import RxDataSources
import FBCocoa
import FBBean
import FBHud
import MJRefresh

@objc (FBCommentBridge)
public final class FBCommentBridge: FBBaseBridge {
    
    typealias Section = FBAnimationSetionModel<FBCommentBean>
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<Section>!
    
    var viewModel: FBCommentViewModel!
    
    weak var vc: FBTableLoadingViewController!
    
    var circleBean: FBCircleBean!
}
extension FBCommentBridge {
    
    @objc public func createComment(_ vc: FBTableLoadingViewController,encode: String ,circle: FBCircleBean) {
        
        self.vc = vc
        
        self.circleBean = circle
        
        let input = FBCommentViewModel.WLInput(modelSelect: vc.tableView.rx.modelSelected(FBCommentBean.self),
                                              itemSelect: vc.tableView.rx.itemSelected,
                                              headerRefresh: vc.tableView.mj_header!.rx.FBRefreshing.asDriver(),
                                              footerRefresh: vc.tableView.mj_footer!.rx.FBRefreshing.asDriver(),
                                              encoded: encode)
        
        viewModel = FBCommentViewModel(input, disposed: disposed)
        
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
            .drive(vc.tableView.mj_header!.rx.FBEndRefreshing)
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
                    
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
        let endFooterRefreshing = viewModel.output.endFooterRefreshing
        
        endFooterRefreshing
            .map({ _ in return true })
            .drive(vc.tableView.mj_footer!.rx.FBEndRefreshing)
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
    @objc public func insertComment(_ comment: FBCommentBean) {
        
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
    @objc public func addComment(_ encoded: String,content: String ,commentAction: @escaping (_ comment: FBCommentBean? ,_ circleBean: FBCircleBean) -> () ) {
        
        FBHud.show(withStatus: "发布评论中....")
        
        FBCommentViewModel
            .addComment(encoded, content: content)
            .drive(onNext: { [unowned self](result) in
                
                FBHud.pop()
                
                switch result {
                case .operation(let comment):
                    
                    FBHud.showInfo("发布评论成功!")
                    
                    self.circleBean.countComment += 1
                    
                    self.insertComment(comment as! FBCommentBean)
                    
                    commentAction(comment as? FBCommentBean ,self.circleBean)

                case .failed(let msg):
                    
                    FBHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
}

extension FBCommentBridge: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let datasource = dataSource else { return 0}
        
        return vc.caculate(forCell: datasource[indexPath], for: indexPath)
    }
}
