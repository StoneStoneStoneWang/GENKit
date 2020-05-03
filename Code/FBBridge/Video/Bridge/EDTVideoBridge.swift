//
//  FBVideoBridge.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/22.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import FBTransition
import FBHud
import FBCache

@objc(FBVideoActionType)
public enum FBVideoActionType: Int ,Codable {
    
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

public typealias FBVideoAction = (_ action: FBVideoActionType) -> ()

@objc (FBVideoBridge)
public final class FBVideoBridge: FBBaseBridge {
    
    var viewModel: FBVideoViewModel!
    
    weak var vc: FBTViewController!
}
extension FBVideoBridge {
    
    @objc public func createVideo(_ vc: FBTViewController) {
        
        self.vc = vc
    }
}
extension FBVideoBridge {
    
    @objc public func addBlack(_ OUsEncoded: String,targetEncoded: String ,content: String ,action: @escaping FBVideoAction) {
        
        if !FBAccountCache.default.isLogin() {
            
            action(.unLogin)
            
            return
        }
        
        FBHud.show(withStatus: "添加黑名单中...")
        
        FBVideoViewModel
            .addBlack(OUsEncoded, targetEncoded: targetEncoded, content: content)
            .drive(onNext: { (result) in
                
                FBHud.pop()
                
                switch result {
                case .ok(let msg):
                
                    FBHud.showInfo(msg)
                    
                    action(.black)
                    
                case .failed(let msg):
                    
                    FBHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
    @objc public func focus(_ uid: String ,encode: String ,isFocus: Bool,action: @escaping FBVideoAction) {
        
        if !FBAccountCache.default.isLogin() {
            
            action(.unLogin)
            
            return
        }
        
        FBHud.show(withStatus: isFocus ? "取消关注中..." : "关注中...")
        
        FBVideoViewModel
            .focus(uid, encode: encode)
            .drive(onNext: { (result) in
                
                FBHud.pop()
                
                switch result {
                case .ok:
                    
                    action(.focus)
                    
                    FBHud.showInfo(isFocus ? "取消关注成功" : "关注成功")
                case .failed(let msg):
                    
                    FBHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
    }

    @objc public func like(_ encoded: String,isLike: Bool,action: @escaping FBVideoAction) {
        
        if !FBAccountCache.default.isLogin() {
            
            action(.unLogin)
            
            return
        }
        
        FBHud.show(withStatus: isLike ? "取消点赞中..." : "点赞中...")
        
        FBVideoViewModel
            .like(encoded, isLike: !isLike)
            .drive(onNext: {(result) in
                
                FBHud.pop()
                
                switch result {
                case .ok(let msg):
                
                    action(.like)
                    
                    FBHud.showInfo(msg)
                case .failed(let msg):
                    
                    FBHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
}
