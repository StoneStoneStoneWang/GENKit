//
//  FBObserverReq.swift
//  FBObserverReq
//
//  Created by 王磊 on 2020/4/16.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import Alamofire

public protocol FBObservableReq {
    /*
     reqName 请求接口名 如 app/user/v1/login
     */
    var reqName: String { get }
    /*
     params 请求 参数
     */
    var params: Dictionary<String,Any> { get }
    /*
     params 请求头
     */
    var headers: Dictionary<String,String> { get }
    
    var method: HTTPMethod { get }
    
    var host: String { get }
}
