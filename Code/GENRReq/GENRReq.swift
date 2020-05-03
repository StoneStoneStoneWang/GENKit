//
//  ZRealReq.swift
//  ZRealReq
//
//  Created by three stone 王 on 2019/8/22.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import RxSwift
import FBCache
import FBReq
import FBUpload
import FBSign
import FBError
import FBObservableReq

public func FBDictResp<T : FBObservableReq>(_ req: T) -> Observable<[String:Any]> {
    
    return Observable<[String:Any]>.create({ (observer) -> Disposable in
        
        var params = req.params
        
        if !FBAccountCache.default.token.isEmpty {
            
            params.updateValue(FBAccountCache.default.token, forKey: "token")
        }
        
        FBReq.postWithUrl(url: req.host + req.reqName, params: params, header: req.headers, succ: { (data) in
            
            observer.onNext(data as! [String:Any])
            
            observer.onCompleted()
        }, fail: { (error) in
            
            let ocError = error as NSError
            
            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(FBError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

public func FBArrayResp<T : FBObservableReq>(_ req: T) -> Observable<[Any]> {
    
    return Observable<[Any]>.create({ (observer) -> Disposable in
        
        var params = req.params
        
        if !FBAccountCache.default.token.isEmpty {
            
            params.updateValue(FBAccountCache.default.token, forKey: "token")
        }
        FBReq.postWithUrl(url: req.host + req.reqName, params: params, header: req.headers, succ: { (data) in

            observer.onNext(data as! [Any])

            observer.onCompleted()

        }, fail: { (error) in

            let ocError = error as NSError

            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(FBError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

// 无返回值的 在data里
public func FBVoidResp<T : FBObservableReq>(_ req: T) -> Observable<Void> {
    
    return Observable<Void>.create({ (observer) -> Disposable in
        
        var params = req.params
        
        if !FBAccountCache.default.token.isEmpty {
            
            params.updateValue(FBAccountCache.default.token, forKey: "token")
        }
        
        FBReq.postWithUrl(url: req.host + req.reqName, params: params, header: req.headers, succ: { (data) in

            observer.onNext(())

            observer.onCompleted()

        }, fail: { (error) in

            let ocError = error as NSError

            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(FBError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

public func FBAliResp<T : FBObservableReq>(_ req: T) -> Observable<FBALCredentialsBean> {
    
    return Observable<FBALCredentialsBean>.create({ (observer) -> Disposable in
        
        var params = req.params
        
        if !FBAccountCache.default.token.isEmpty {
            
            params.updateValue(FBAccountCache.default.token, forKey: "token")
        }
        FBUpload.fetchAliObj(withUrl: req.host + req.reqName , andParams: params, andHeader: req.headers, andSucc: { (credentials) in

            observer.onNext(credentials)

            observer.onCompleted()

        }, andFail: { (error) in

            let ocError = error as NSError

            if ocError.code == 131 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }

            else { observer.onError(FBError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

public func FBUploadImgResp(_ data: Data ,file: String ,param: FBALCredentialsBean) -> Observable<String> {
    
    return Observable<String>.create({ (observer) -> Disposable in
        
        FBUpload.uploadAvatar(with: data, andFile: file, andUid: FBAccountCache.default.uid, andParams: param, andSucc: { (objKey) in

            observer.onNext(objKey)

            observer.onCompleted()

        }, andFail: { (error) in

            let ocError = error as NSError

            if ocError.code == 132 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }

            else { observer.onError(FBError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}

public func FBUploadPubImgResp(_ data: Data ,file: String ,param: FBALCredentialsBean) -> Observable<String> {
    
    return Observable<String>.create({ (observer) -> Disposable in
        
        FBUpload.uploadImage(with: data, andFile: file, andUid: FBAccountCache.default.uid, andParams: param, andSucc: { (objKey) in

            observer.onNext(objKey)

            observer.onCompleted()

        }, andFail: { (error) in

            let ocError = error as NSError

            if ocError.code == 132 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }

            else { observer.onError(FBError.HTTPFailed(error)) }
        })
        
        return Disposables.create { }
    })
}
public func FBUploadVideoResp(_ data: Data ,file: String ,param: FBALCredentialsBean) -> Observable<String> {
    
    return Observable<String>.create({ (observer) -> Disposable in
        
        FBUpload.uploadVideo(with: data, andFile: file, andUid: FBAccountCache.default.uid, andParams: param, andSucc: { (objKey) in

            observer.onNext(objKey)

            observer.onCompleted()

        }, andFail: { (error) in

            let ocError = error as NSError

            if ocError.code == 132 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }

            else { observer.onError(FBError.HTTPFailed(error)) }
        })
//
        return Disposables.create { }
    })
}

public func FBTranslateResp<T : FBObservableReq>(_ req: T) -> Observable<[String:Any]> {
    
    return Observable<[String:Any]>.create({ (observer) -> Disposable in
        
        FBReq.postTranslateWithParams(params: req.params, succ: { (data) in
            observer.onNext(data as! [String:Any])
            
            observer.onCompleted()
        }, fail: { (error) in
            
            let ocError = error as NSError
            
            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(FBError.HTTPFailed(error)) }
        })
        return Disposables.create { }
    })
}

public func FBAreaResp<T : FBObservableReq>(_ req: T) -> Observable<[Any]> {
    
    return Observable<[Any]>.create({ (observer) -> Disposable in
        
        FBReq.postAreaWithUrl(url: req.host + req.reqName, params: req.params, succ: { (data) in
            
            if data is NSDictionary {
                
                observer.onError(FBError.ServerResponseError("没有权限"))
            } else if data is NSArray {
                
                observer.onNext(data as! [Any])
                
                observer.onCompleted()
            }

        }, fail: { (error) in
            
            let ocError = error as NSError
            
            if ocError.code == 122 || ocError.code == 123 || ocError.code == 124 || ocError.code == 121 { observer.onError(FBError.ServerResponseError(ocError.localizedDescription)) }
            else { observer.onError(FBError.HTTPFailed(error)) }
        })
        
        
        return Disposables.create { }
    })
}
