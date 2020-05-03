//
//  FBFReq.swift
//  FBFReq
//
//  Created by 王磊 on 2020/4/16.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import WLToolsKit
import FBObservableReq

// MARK: FBSendReq
public func FBSendReq<T : FBObservableReq>(_ req: T) -> Observable<[String:Any]> {
    
    return Observable<[String:Any]>.create({ (observer) -> Disposable in
        
        AF.request(URL(string: req.host + req.reqName)!, method: req.method, parameters: req.params, encoding: URLEncoding.default, headers: HTTPHeaders(req.headers)).responseJSON { (response) in
            
            switch response.result {
                
            case let .success(result):
                
                observer.onNext(result as! [String : Any])
                
                observer.onCompleted()
                
            case let .failure(error):
                
                observer.onError(error)
            }
        }
        
        return Disposables.create { }
    })
}
// MARK: FBUploadStatus
public enum FBUploadStatus {
    
    case begin
    
    case uploading(_ percent: CGFloat)
    
    case succ(_ result: [String: Any])
    
    case error(_ error: String)
}

// MARK: uploadImage
public func FBUploadImage<T : FBObservableReq>(_ req: T,img: UIImage ,filename: String) -> Observable<FBUploadStatus> {
    
    return Observable<FBUploadStatus>.create({ (observer) -> Disposable in
        
        AF.upload(multipartFormData: { (form) in
            let data = UIImage.compressImage(img, maxLength: 50 * 1024)
            
            form.append(data, withName: "file", fileName: UIImage.wl_imagePath(data: data, imageName: filename), mimeType: "image/png")
        }, to: URL(string: req.host + req.reqName)!)
            .responseJSON(completionHandler: { (response ) in
                
                switch response.result{
                    
                case let .success(result):
                    observer.onNext(.succ(result as! [String : Any]))
                    
                    observer.onCompleted()
                    
                case let .failure(error):
                    
                    observer.onError(error)
                }
            })
        
        return Disposables.create { }
    })
}
// MARK: uploadVideo
public func FBUploadVideo<T : FBObservableReq>(_ req: T ,data: Data,filename: String) -> Observable<FBUploadStatus> {
    
    return Observable<FBUploadStatus>.create({ (observer) -> Disposable in
        
        AF.upload(multipartFormData: { (form) in
            observer.onNext(FBUploadStatus.begin)
            
            form.append("file".data(using: .utf8)!, withName: "name")
            
            form.append(data, withName: "file", fileName: filename, mimeType: "video/mp4")
            
        }, to: URL(string: req.host + req.reqName)!)
            .responseJSON(completionHandler: { (response ) in
                
                switch response.result{
                    
                case let .success(result):
                    observer.onNext(.succ(result as! [String : Any]))
                    
                    observer.onCompleted()
                    
                case let .failure(error):
                    
                    observer.onError(error)
                }
            })
        
        return Disposables.create { }
    })
}
