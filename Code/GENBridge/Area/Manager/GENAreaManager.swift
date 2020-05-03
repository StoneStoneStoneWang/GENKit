//
//  GENAreaManager.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/19.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import GENBean
import GENYY
import RxCocoa
import GENResult
import RxSwift
import GENReq
import GENApi
import Alamofire
import GENRReq
import GENObservableMapper
import GENError

@objc (GENAreaManager)
public class GENAreaManager: NSObject {
    
    @objc (shared)
    public static let `default`: GENAreaManager = GENAreaManager()
    
    private override init() { }
    // 全部地区
    @objc public var allAreas: [GENAreaBean] = []
}

extension GENAreaManager {
    
      public func fetchAreas() -> Driver<GENResult> {
        
        if allAreas.count > 0 {
            
            return Driver.just(GENResult.fetchList(allAreas))
        } else {
            
            if isAreaFileExist() {
                
                let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
                
                let targetPath = cachePath + "/Areas"
                
                if let arr = NSArray(contentsOfFile: targetPath) {
                    
                    var mutable: [GENAreaBean] = []
                    
                    for item in arr {
                        
                        mutable += [GENAreaBean(JSON: item as! [String: Any])!]
                    }
                    
                    allAreas += mutable
                    
                    return Driver.just(GENResult.fetchList(mutable))
                }
                
                return Driver.just(GENResult.failed("获取本地数据失败!"))
            } else {
                
                return GENAreaResp(GENApi.fetchAreaJson)
                    .map({ GENAreaManager.default.saveArea($0) })
                    .map({ _ in GENResult.fetchList(GENAreaManager.default.allAreas)  })
                    .asDriver(onErrorRecover: { return Driver.just(GENResult.failed(($0 as! GENError).description.0)) })
            }
        }
    }
    
   @objc public func fetchSomeArea(_ id: Int)  -> GENAreaBean {
        
        assert(allAreas.count > 0, "请先调用 fetchArea")
        
        var result: GENAreaBean!
        
        for item in allAreas {
            
            if item.areaId == id {
                
                result = item
                
                break
            }
        }
        
        return result ?? GENAreaBean()
    }
    
   @objc public func saveArea(_ areas: [Any]) -> [Any] {
        
        for item in areas {
            
            allAreas += [GENAreaBean(JSON: item as! [String: Any])!]
        }
        
        let mutable = NSMutableArray()
        
        mutable.addObjects(from: areas)
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        
        let targetPath = cachePath + "/Areas"
        
        mutable.write(toFile: targetPath, atomically: true)
        
        return areas
    }
    
    public func isAreaFileExist() -> Bool {
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        
        let targetPath = cachePath + "/Areas"
        
        return FileManager.default.fileExists(atPath: targetPath)
    }
}
