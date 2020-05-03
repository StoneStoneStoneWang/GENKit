//
//  WLApiImpl.swift
//  SPrepare
//
//  Created by three stone 王 on 2019/6/24.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import FBObservableReq
import Alamofire
import WLToolsKit
import FBSign

extension FBApi: FBObservableReq {
    public var reqName: String {
        
        switch self {
            
        case .login: return "other/login_mobLoginPhone?"
            
        case .swiftLogin: return "other/login_mobQuickLogin?"
            
        case .smsCode: return "mob/sms_mobSendQuickLoginCode?"
            
        case .reg: return "mob/users_mobPhoneAddUsers?"
            
        case .feedback: return "mob/feedback_mobFeedbackAdd?"
            
        case .fetchProfile: return "mob/users_mobUsersInfo?"
            
        case .updateUserInfo: return "mob/users_mobUsersUpdate?"
            
        case .smsPassword: return "mob/sms_mobSendForgetPwdCode?"
            
        case .resettingPassword: return "mob/users_mobForgetPassword?"
            
        case .modifyPassword: return "mob/users_mobUpdatePassword?"
            
        case .aliToken: return "other/oss_stsAssumeRole?"
            
        case .fetchBlackList: return "mob/blacklist_mobListBlacklist?"
            
        case .removeBlack: return "mob/blacklist_mobDelBlacklist"
            
        case .focus: return "mob/attention_mobSucrAttention?"
            
        case .fetchMyFocus: return "mob/attention_mobListAttention?"
            
        case .publish: return "mob/circleFriends_mobAddCircleFriends?"
            
        case .fetchList: return "mob/circleFriends_mobListCircleFriends?"
            
        case .fetchMyList: return "mob/circleFriends_mobUserCircleFriends?"
            
        case .fetchComments: return "mob/comment_mobListComment?"
            
        case .addComment: return "mob/comment_mobAddComment?"
            
        case .like: return "mob/laud_mobAddLaud?"
            
        case .report: return "mob/report_mobReportAdd?"
            
        case .addBlack: return "mob/blacklist_mobAddBlacklist?"
            
        case .fetchPublish: return "mob/circleFriends_mobUserCircleFriends?"
            
        case .attention: return "mob/attention_mobSucrAttention?"
            
        case .fetchAddress: return "mob/profile_mobListProfile?"
            
        case .editAddress: return "mob/profile_mobSucrProfile?"
            
        case .deleteAddress: return "mob/profile_mobDelProfile?"
            
        case .fetchAreaJson: return "mob/addr_mobAddrJsonFile?"
            
        case .fetchBanners: return "mob/circleFriends_mobListCircleFriends?"
            
        case .deleteMyCircle: return "mob/circleFriends_mobDelCircleFriends?"
            
        case .analysis: return "mob/location_mobAddLocation?"
            
        case .fetchTags: return "mob/circleFriends_mobListTag?"
            
        case .updateCircle: return "mob/circleFriends_mobUpdateCircleFriends?"
            
        case .fetchFirstMsg: return "mob/logs_mobListLogs?"
            
        case .fetchSystemMsg: return "mob/logs_mobListLogs?"
            
        case .readMsg: return "mob/logs_mobReadLogs?"
        }
    }
    
    public var params: Dictionary<String, Any> {
        
        switch self {
        case let .login(phone, password: password): return ["phone": phone,"password": password,"platform": "1" ,"deviceId": DeviceId,"deviceModel": DeviceModel]
            
        case let .smsCode(phone): return ["phone": phone,"signName":FBConfigure.fetchSmsSign(),"templateCode":FBConfigure.fetchSmsLogin()]
            
        case let .swiftLogin(phone, code): return ["phone":phone,"code":code,"platform":"1","deviceModel": DeviceModel]
            
        case let .reg(phone, password: password, code: code): return ["phone": phone,"password": password,"platform": "1","code": code,"openid": "","deviceModel": DeviceModel]
            
        case let .feedback(email, content: content): return ["fb.email": email,"fb.content": content]
            
        case .fetchProfile: return ["platform": "1"]
            
        case let .updateUserInfo(key, value: value): return [key: value]
            
        case let .smsPassword(phone): return ["phone": phone,"signName":FBConfigure.fetchSmsSign(),"templateCode":FBConfigure.fetchSmsPwd()]
            
        case let .resettingPassword(phone, password: password, code: code): return ["phone": phone,"password": password,"platform": "1","code": code,"deviceModel": DeviceModel]
            
        case let .modifyPassword(oldPassword, password: password): return ["oldPassword": oldPassword,"password": password,"deviceModel": DeviceModel]
            
        case .fetchBlackList: return ["projectId":FBConfigure.fetchAppKey()]
            
        case .aliToken: return [:]
            
        case let .removeBlack(encoded): return ["projectId":FBConfigure.fetchAppKey(),"bt.encoded": encoded]
            
        case let .focus(OUsEncoded, targetEncoded: targetEncoded): return ["atn.OUsEncoded":OUsEncoded,"atn.targetEncoded":targetEncoded,"projectId": FBConfigure.fetchAppKey(),"atn.tableName":"Users"]
        case let .fetchMyFocus(page): return ["page":page,"projectId": FBConfigure.fetchAppKey()]
            
        case let .publish(tag,content: content): return ["cfs.tag":tag,"cfs.projectId":FBConfigure.fetchAppKey(),"cfs.content":content]
            
        case let .fetchList(tag, page: page): return ["cfs.tag":tag,"cfs.projectId":FBConfigure.fetchAppKey(),"page":page]
            
        case let .fetchMyList(tag, page: page): return ["cfs.tag":tag,"cfs.projectId":FBConfigure.fetchAppKey(),"page":page]
            
        case let .fetchComments(page, targetEncoded: targetEncoded):
            
            return ["comment.targetEncoded":targetEncoded,"page":page,"limit": 20,"projectId": FBConfigure.fetchAppKey()]
            
        case let .addComment(targetEncoded, content: content, tablename: tablename, type: type):
            
            return ["comment.targetEncoded":targetEncoded,"comment.content":content,"comment.tableName": tablename,"comment.type": type,"projectId": FBConfigure.fetchAppKey()]
            
        case let .like(targetEncoded): return ["targetEncoded":targetEncoded]
            
        case let .report(OUsEncoded, targetEncoded: targetEncoded, type: type, content: content):
            
            return ["rt.OUsEncoded":OUsEncoded,"rt.targetEncoded":targetEncoded,"rt.type": type,"rt.content": content,"rt.projectId": FBConfigure.fetchAppKey(),"rt.tableName": "CircleFriends"]
        case let .addBlack(OUsEncoded, targetEncoded: targetEncoded, content: content):
            
            return ["bt.OUsEncoded":OUsEncoded,"bt.targetEncoded":targetEncoded,"bt.content": content,"projectId": FBConfigure.fetchAppKey(),"bt.tableName": "CircleFriends"]
            
        case let .attention(OUsEncoded, targetEncoded: targetEncoded): return ["atn.OUsEncoded":OUsEncoded,"atn.targetEncoded":targetEncoded,"projectId": FBConfigure.fetchAppKey(),"atn.tableName":"Users"]
            
        case let .fetchPublish(tag, page: page, userId: userId): return ["cfs.projectId":FBConfigure.fetchAppKey(),"cfs.tag": tag,"page": page,"userId": userId]
            
        case .fetchAddress: return [:]
            
        case let .deleteAddress(encode): return ["pe.encoded":encode]
            
        case .fetchBanners: return ["cfs.tag":"","cfs.projectId":FBConfigure.fetchAppKey(),"page":1]
            
        case let .editAddress(encode, name: name, phone: phone, plcl: plcl, plclne: plclne, city: city, cityne: cityne, region: region, regionne: regionne, addr: addr, isdef: isdef, zipCode: zipCode):
            
            var result: [String : Any] = ["name": name,"phone":phone,"plcl": plcl,"plclne": plclne,"city": city,"cityne": cityne,"addr": addr,"isdef": isdef,"zipCode":zipCode]
            
            if !encode.isEmpty {
                
                result.updateValue(encode, forKey: "encoded")
            }
            
            if !regionne.isEmpty {
                
                result.updateValue(region, forKey: "region")
                
                result.updateValue(regionne, forKey: "regionne")
            }
            
            return result
            
        case .deleteMyCircle(let encode): return ["cfs.encoded": encode,"cfs.projectId":FBConfigure.fetchAppKey()]
            
        case .fetchAreaJson: return [:]
            
        case .analysis(let appId, lat: let lat, lon: let lon):
            
            var result = ["loc.appleId":appId ,"loc.latitude": lat,"loc.longitude": lon]
            
            if let idfa = UIDevice.current.identifierForVendor{
                
                result.updateValue(idfa.uuidString, forKey: "loc.idfa")
            }
            
            return result
            
        case .fetchTags: return [:]
            
        case .updateCircle(let tag, content: let content, encode: let encode):
            
            return ["cfs.tag":tag,"cfs.projectId":FBConfigure.fetchAppKey(),"cfs.content":content,"cfs.encoded": encode]
            
        case .fetchSystemMsg(let page):
            
            return ["projectId":FBConfigure.fetchAppKey(),"page":page,"limit":"10"]
        case .fetchFirstMsg:
            
            return ["projectId":FBConfigure.fetchAppKey(),"page":"1","limit":"1"]
        case .readMsg(let id):
            
            return ["projectId":FBConfigure.fetchAppKey(),"id":id]
        }
        
    }
    
    public var headers: Dictionary<String, String> {
        
        switch self {
            
        default: return [:]
            
        }
    }
    
    public var method: HTTPMethod {
        switch self {
            
        default: return .post
            
        }
    }
    
    public var host: String {
        
        switch self {
            
        default: return FBConfigure.fetchDomain()
            
        }
    }
}
