//
//  FBAreaManager.swift
//  ZBombBridge
//
//  Created by three stone 王 on 2020/3/19.
//  Copyright © 2020 three stone 王. All rights reserved.
//

import Foundation
import FBBean
import FBYY
import RxCocoa
import FBResult
import RxSwift
import FBReq
import FBApi
import Alamofire
import FBRReq
import FBObservableMapper
import FBError

@objc (FBAreaManager)
public class FBAreaManager: NSObject {
    
    @objc (shared)
    public static let `default`: FBAreaManager = FBAreaManager()
    
    private override init() { }
    // 全部地区
    @objc public var allAreas: [FBAreaBean] = []
}

extension FBAreaManager {
    
      public func fetchAreas() -> Driver<FBResult> {
        
        if allAreas.count > 0 {
            
            return Driver.just(FBResult.fetchList(allAreas))
        } else {
            
            if isAreaFileExist() {
                
                let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
                
                let targetPath = cachePath + "/Areas"
                
                if let arr = NSArray(contentsOfFile: targetPath) {
                    
                    var mutable: [FBAreaBean] = []
                    
                    for item in arr {
                        
                        mutable += [FBAreaBean(JSON: item as! [String: Any])!]
                    }
                    
                    allAreas += mutable
                    
                    return Driver.just(FBResult.fetchList(mutable))
                }
                
                return Driver.just(FBResult.failed("获取本地数据失败!"))
            } else {
                
                return FBAreaResp(FBApi.fetchAreaJson)
                    .map({ FBAreaManager.default.saveArea($0) })
                    .map({ _ in FBResult.fetchList(FBAreaManager.default.allAreas)  })
                    .asDriver(onErrorRecover: { return Driver.just(FBResult.failed(($0 as! FBError).description.0)) })
            }
        }
    }
    
   @objc public func fetchSomeArea(_ id: Int)  -> FBAreaBean {
        
        assert(allAreas.count > 0, "请先调用 fetchArea")
        
        var result: FBAreaBean!
        
        for item in allAreas {
            
            if item.areaId == id {
                
                result = item
                
                break
            }
        }
        
        return result ?? FBAreaBean()
    }
    
   @objc public func saveArea(_ areas: [Any]) -> [Any] {
        
        for item in areas {
            
            allAreas += [FBAreaBean(JSON: item as! [String: Any])!]
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
