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
    case category(String, Int)
    case logonToken(String)
}

extension Logon: TargetType {
    public var baseURL: URL {
        return "http://localhost:8080".url!
    }
    
    public var path: String {
        switch self {
        case .category(let category, let page):
            return "/category/\(category)/page/\(page)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        switch self {
        case .category(let category, let page):
            return "{\"category\": \"\(category)\", \"page\": \(page)}".data(using: String.Encoding.utf8)!
        }
    }
    
    public var task: Task {
        switch self {
        case .category( _, _):
            return .requestPlain
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
    static let provider = MoyaProvider<DouBan>()
    // 发送网络请求
    static func request( target: DouBan,
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
