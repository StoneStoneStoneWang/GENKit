//
//  GENError.swift
//  GENError
//
//  Created by 王磊 on 2020/4/16.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation

public enum GENError: Error {
    
    case HTTPFailed(_ error: Error)
    
    case MapperError(_ msg: String)
    
    case ServerResponseError(_ msg: String)
}

extension GENError {
    
    public var description: (String,Error?) {
        
        switch self {
        case let .HTTPFailed(e):
            
            return (e.localizedDescription,e)
        case let .MapperError(msg):
            
            return (msg ,nil)
        case let .ServerResponseError(msg):
            
            return (msg ,nil)
        }
    }
}
