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
    case logonToken(String)
    case contact
}

extension Logon: TargetType {
    public var baseURL: URL {
        return "http://192.168.1.2:8181".url!
    }
    
    public var path: String {
        switch self {
        case .logonToken(_):
            return "users/login"
        case .contact:
            return "contact"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .logonToken:
            return .post
        case .contact:
            return .post
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .logonToken(let logonToken):
            return "{\"category\": \"\(logonToken)\", \"page\": \(logonToken)}".data(using: String.Encoding.utf8)!
        case .contact:
            return "2008".data(using: String.Encoding.utf8)!
        }
    }
    
    public var task: Task {
        var params:[String : Any] = [:]
        // 添加公共参数
//        params["v"] = ProjectInfo.appVersionWithOutPoint()
//        params["dev"] = ProjectInfo.platform()
        
        switch self {
        case .logonToken( let logonToken ):
            params["loginToken"] = logonToken
//            return .requestJSONEncodable(["loginToken": "account"])
//            return .requestData(jsonToData(jsonDic: ["loginToken":"account"  ,"last_name":"password"])!) //参数放在HttpBody中
//            return .requestParameters(parameters: ["loginToken": "firstName", "last_name": "lastName"], encoding: JSONEncoding.default)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .contact:
            return .requestPlain
        }
    }
    
    
    
    public var headers: [String: String]? {
//        return nil
        return ["Content-type": "application/json"]
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
