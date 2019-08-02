//
//  LogonApi.swift
//  ImitateMeizi
//
//  Created by wsk on 2019/7/29.
//  Copyright © 2019 hml. All rights reserved.
//

import Foundation
import Moya

public enum Logon {
    case login1(String)
    case login2(String)
    case login3(String)
    case login4(String)
    case login5(String)
    case login6(String)
}

extension Logon: TargetType {
    public var baseURL: URL {
        let isAtHome: Bool = false
        if isAtHome {
            return "http://192.168.1.2:8181".url!
        }
        else {
            return "http://10.1.1.141:8181".url!
        }
    }
    
    public var path: String {
        switch self {
        case .login1(_):
            return "users/login"
        case .login2(_):
            return "users/login"
        case .login3(_):
            return "users/login"
        case .login4(_):
            return "users/login"
        case .login5(_):
            return "users/login"
        case .login6(_):
            return "users/login"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login1:
            return .post
        case .login2:
            return .post
        case .login3:
            return .post
        case .login4:
            return .post
        case .login5:
            return .post
        case .login6:
            return .post
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .login1:
            return "2008".data(using: String.Encoding.utf8)!
        case .login2:
            return "2008".data(using: String.Encoding.utf8)!
        case .login3:
            return "2008".data(using: String.Encoding.utf8)!
        case .login4:
            return "2008".data(using: String.Encoding.utf8)!
        case .login5:
            return "2008".data(using: String.Encoding.utf8)!
        case .login6:
            return "2008".data(using: String.Encoding.utf8)!
        }
    }
    
    /// 1、2、4、6可以被golang解析，3和5不可以
    public var task: Task {
        var params:[String : Any] = [:]
        // 添加公共参数
//        params["v"] = ProjectInfo.appVersionWithOutPoint()
//        params["dev"] = ProjectInfo.platform()
        switch self {
        case .login1( let logonToken ):
            params["loginToken"] = logonToken
            return .requestJSONEncodable(["loginToken": logonToken])
            
        case .login2( let logonToken ):
            params["loginToken"] = logonToken
            return .requestData(jsonToData(jsonDic: ["loginToken": logonToken])!) //参数放在HttpBody中
            
        case .login3( let logonToken ):
            params["loginToken"] = logonToken
            return .requestParameters(parameters: params, encoding: PropertyListEncoding.default)
            
        case .login4( let logonToken ):
            params["loginToken"] = logonToken
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .login5( let logonToken ):
            params["loginToken"] = logonToken
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .login6( let logonToken ):
            params["loginToken"] = logonToken
            return .requestParameters(parameters: ["loginToken": logonToken], encoding: JSONEncoding.default)
        }
    }
    
    
    
    public var headers: [String: String]? {
        return nil
//        return ["Content-type": "application/json"]
    }
}
//------------------------
//字典转Data
private func jsonToData(jsonDic:Dictionary<String, Any>) -> Data? {
    if (!JSONSerialization.isValidJSONObject(jsonDic)) {
        print("is not a valid json object")
        return nil
    }
    //利用自带的json库转换成Data
    //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
    //Data转换成String打印输出
    let str = String(data:data!, encoding: String.Encoding.utf8)
    //输出json字符串
    print("Json Str:\(str!)")
    return data
}

// 网络请求结构体
struct LogonNetwork {
    // 请求成功的回调
    typealias successCallback = (_ result: Any) -> Void
    // 请求失败的回调
    typealias failureCallback = (_ error: MoyaError) -> Void
    // 单例
    static let provider = MoyaProvider<Logon>()
    // 发送网络请求
    static func request( target: Logon,
                         success: @escaping successCallback,
                         failure: @escaping failureCallback ) {
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    try success(moyaResponse.mapJSON())
                }
                catch {
                    failure(MoyaError.jsonMapping(moyaResponse))
                }
            case let .failure(error):
                failure(error)
            }
        }
    }
}
