//
//  FBAreaJson.swift
//  FBBridge
//
//  Created by 王磊 on 2020/4/10.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation

@objc (FBAreaJsonBridge)
public final class FBAreaJsonBridge: FBBaseBridge { }

extension FBAreaJsonBridge {
    @objc (fetchAreas)
    public func fetchAreas() {
        
        FBAreaManager
            .default
            .fetchAreas()
            .drive(onNext: { (result) in
                
                
            })
            .disposed(by: disposed)
    }
}
