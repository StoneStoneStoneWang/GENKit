//
//  GENAreaJson.swift
//  GENBridge
//
//  Created by 王磊 on 2020/4/10.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation

@objc (GENAreaJsonBridge)
public final class GENAreaJsonBridge: GENBaseBridge { }

extension GENAreaJsonBridge {
    @objc (fetchAreas)
    public func fetchAreas() {
        
        GENAreaManager
            .default
            .fetchAreas()
            .drive(onNext: { (result) in
                
                
            })
            .disposed(by: disposed)
    }
}
