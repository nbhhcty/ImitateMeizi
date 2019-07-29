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
}

extension Logon: TargetType {
    public var baseURL: URL {
        return "http://localhost:8080".url!
    }
    
    public var path: String {
        switch self {
        case .logonToken(_):
            return "users/loginJgQuickAuth"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .logonToken:
            return .get
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .logonToken(let logonToken):
            return "{\"category\": \"\(logonToken)\", \"page\": \(logonToken)}".data(using: String.Encoding.utf8)!
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
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
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
