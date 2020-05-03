//
//  GENVideoBridge.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/22.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENTransition
import GENHud
import GENCache

@objc(GENVideoActionType)
public enum GENVideoActionType: Int ,Codable {
    
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

public typealias GENVideoAction = (_ action: GENVideoActionType) -> ()

@objc (GENVideoBridge)
public final class GENVideoBridge: GENBaseBridge {
    
    var viewModel: GENVideoViewModel!
    
    weak var vc: GENTViewController!
}
extension GENVideoBridge {
    
    @objc public func createVideo(_ vc: GENTViewController) {
        
        self.vc = vc
    }
}
extension GENVideoBridge {
    
    @objc public func addBlack(_ OUsEncoded: String,targetEncoded: String ,content: String ,action: @escaping GENVideoAction) {
        
        if !GENAccountCache.default.isLogin() {
            
            action(.unLogin)
            
            return
        }
        
        GENHud.show(withStatus: "添加黑名单中...")
        
        GENVideoViewModel
            .addBlack(OUsEncoded, targetEncoded: targetEncoded, content: content)
            .drive(onNext: { (result) in
                
                GENHud.pop()
                
                switch result {
                case .ok(let msg):
                
                    GENHud.showInfo(msg)
                    
                    action(.black)
                    
                case .failed(let msg):
                    
                    GENHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
    @objc public func focus(_ uid: String ,encode: String ,isFocus: Bool,action: @escaping GENVideoAction) {
        
        if !GENAccountCache.default.isLogin() {
            
            action(.unLogin)
            
            return
        }
        
        GENHud.show(withStatus: isFocus ? "取消关注中..." : "关注中...")
        
        GENVideoViewModel
            .focus(uid, encode: encode)
            .drive(onNext: { (result) in
                
                GENHud.pop()
                
                switch result {
                case .ok:
                    
                    action(.focus)
                    
                    GENHud.showInfo(isFocus ? "取消关注成功" : "关注成功")
                case .failed(let msg):
                    
                    GENHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
    }

    @objc public func like(_ encoded: String,isLike: Bool,action: @escaping GENVideoAction) {
        
        if !GENAccountCache.default.isLogin() {
            
            action(.unLogin)
            
            return
        }
        
        GENHud.show(withStatus: isLike ? "取消点赞中..." : "点赞中...")
        
        GENVideoViewModel
            .like(encoded, isLike: !isLike)
            .drive(onNext: {(result) in
                
                GENHud.pop()
                
                switch result {
                case .ok(let msg):
                
                    action(.like)
                    
                    GENHud.showInfo(msg)
                case .failed(let msg):
                    
                    GENHud.showInfo(msg)
                default:
                    break
                }
            })
            .disposed(by: disposed)
    }
}
