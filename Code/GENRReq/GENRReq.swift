//
//  ZRealReq.swift
//  ZRealReq
//
//  Created by three stone 王 on 2019/8/22.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxSwift
import GENCache
import GENReq
import GENUpload
import GENSign
import GENError
import GENObservableReq

public func GENDictResp<T : GENObservableReq>(_ req: T) -> Observable<[String:Any]> {
    
    return Observable<[String:Any]>.create({ (observer) -> Disposable in
        
        var params = req.params
        
        if !GENAccountCache.default.token.isEmpty {
            
            params.updateValue(GENAccountCache.default.token, forKey: "token")
        }
        
        GENReq.postWithUrl(url: req.host + req.reqName, params: params, header: req.headers, succ: { (data) in
            
            observer.onNext(data as! [String:Any])
            
            observer.onCompleted()
        }, fail: { (error) in
            
            let ocError = error as NSError
            
            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(GENError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

public func GENArrayResp<T : GENObservableReq>(_ req: T) -> Observable<[Any]> {
    
    return Observable<[Any]>.create({ (observer) -> Disposable in
        
        var params = req.params
        
        if !GENAccountCache.default.token.isEmpty {
            
            params.updateValue(GENAccountCache.default.token, forKey: "token")
        }
        GENReq.postWithUrl(url: req.host + req.reqName, params: params, header: req.headers, succ: { (data) in

            observer.onNext(data as! [Any])

            observer.onCompleted()

        }, fail: { (error) in

            let ocError = error as NSError

            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(GENError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

// 无返回值的 在data里
public func GENVoidResp<T : GENObservableReq>(_ req: T) -> Observable<Void> {
    
    return Observable<Void>.create({ (observer) -> Disposable in
        
        var params = req.params
        
        if !GENAccountCache.default.token.isEmpty {
            
            params.updateValue(GENAccountCache.default.token, forKey: "token")
        }
        
        GENReq.postWithUrl(url: req.host + req.reqName, params: params, header: req.headers, succ: { (data) in

            observer.onNext(())

            observer.onCompleted()

        }, fail: { (error) in

            let ocError = error as NSError

            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(GENError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

public func GENAliResp<T : GENObservableReq>(_ req: T) -> Observable<GENCredentialsBean> {
    
    return Observable<GENCredentialsBean>.create({ (observer) -> Disposable in
        
        var params = req.params
        
        if !GENAccountCache.default.token.isEmpty {
            
            params.updateValue(GENAccountCache.default.token, forKey: "token")
        }
        GENUpload.fetchAliObj(withUrl: req.host + req.reqName , andParams: params, andHeader: req.headers, andSucc: { (credentials) in

            observer.onNext(credentials)

            observer.onCompleted()

        }, andFail: { (error) in

            let ocError = error as NSError

            if ocError.code == 131 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }

            else { observer.onError(GENError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

public func GENUploadImgResp(_ data: Data ,file: String ,param: GENCredentialsBean) -> Observable<String> {
    
    return Observable<String>.create({ (observer) -> Disposable in
        
        GENUpload.uploadAvatar(with: data, andFile: file, andUid: GENAccountCache.default.uid, andParams: param, andSucc: { (objKey) in

            observer.onNext(objKey)

            observer.onCompleted()

        }, andFail: { (error) in

            let ocError = error as NSError

            if ocError.code == 132 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }

            else { observer.onError(GENError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

public func GENUploadPubImgResp(_ data: Data ,file: String ,param: GENCredentialsBean) -> Observable<String> {
    
    return Observable<String>.create({ (observer) -> Disposable in
        
        GENUpload.uploadImage(with: data, andFile: file, andUid: GENAccountCache.default.uid, andParams: param, andSucc: { (objKey) in

            observer.onNext(objKey)

            observer.onCompleted()

        }, andFail: { (error) in

            let ocError = error as NSError

            if ocError.code == 132 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }

            else { observer.onError(GENError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}
public func GENUploadVideoResp(_ data: Data ,file: String ,param: GENCredentialsBean) -> Observable<String> {
    
    return Observable<String>.create({ (observer) -> Disposable in
        
        GENUpload.uploadVideo(with: data, andFile: file, andUid: GENAccountCache.default.uid, andParams: param, andSucc: { (objKey) in

            observer.onNext(objKey)

            observer.onCompleted()

        }, andFail: { (error) in

            let ocError = error as NSError

            if ocError.code == 132 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }

            else { observer.onError(GENError.HTTPFailed(error)) }
        })
//
        return Disposables.create { }
    })
}

public func GENTranslateResp<T : GENObservableReq>(_ req: T) -> Observable<[String:Any]> {
    
    return Observable<[String:Any]>.create({ (observer) -> Disposable in
        
        GENReq.postTranslateWithParams(params: req.params, succ: { (data) in
            observer.onNext(data as! [String:Any])
            
            observer.onCompleted()
        }, fail: { (error) in
            
            let ocError = error as NSError
            
            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(GENError.HTTPFailed(error)) }
        })
        return Disposables.create { }
    })
}

public func GENAreaResp<T : GENObservableReq>(_ req: T) -> Observable<[Any]> {
    
    return Observable<[Any]>.create({ (observer) -> Disposable in
        
        GENReq.postAreaWithUrl(url: req.host + req.reqName, params: req.params, succ: { (data) in
            
            if data is NSDictionary {
                
                observer.onError(GENError.ServerResponseError("没有权限"))
            } else if data is NSArray {
                
                observer.onNext(data as! [Any])
                
                observer.onCompleted()
            }

        }, fail: { (error) in
            
            let ocError = error as NSError
            
            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(GENError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(GENError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}
