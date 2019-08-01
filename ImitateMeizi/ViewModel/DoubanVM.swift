//
//  DoubanVM.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/30.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation
// 请求成功的回调
typealias successCB = (_ oldCount: Int, _ result: Any?) -> Void
// 请求失败的回调
typealias failureCB = (_ error: Any?) -> Void

enum ECategoryType: String {
    case all = "All"
    case daXiong = "DaXiong"
    case qiaoTun = "QiaoTun"
    case heiSi = "HeiSi"
    case meiTui = "MeiTui"
    case qingXin = "QingXin"
    case zaHui = "ZaHui"
}

class DoubanVM {
    
    private var p_curPage: Int = 1
    private var p_hasMoreData: Bool = true

    var p_dataSource:[MeiziIterm] = [] {
        didSet {
            
        }
    }
    
    func reset() {
        self.p_hasMoreData = true
        self.p_curPage = 1
    }

    func loadData(category: ECategoryType, suc: successCB?, fail: failureCB?) {
        guard self.p_hasMoreData == true else {
            if let failure = fail {
                failure(nil)
            }
            return
        }
        LogonNetwork.request(target: .logonToken("123456"), success: { (data) in
            print("data \(data)")
        }) { (error) in
            print("error \(error)")
        }
//        LogonNetwork.request(target: .logonToken("123"), success: { (data) in
//            print("data \(data)")
//        }) { (error) in
//            print("error \(error)")
//        }
        DoubanNetwork.request(target: .category(category.rawValue, self.p_curPage),
                              success: { [weak self] (response) in
                                if let strongSelf = self {
                                    strongSelf.p_curPage = strongSelf.p_curPage + 1
                                    let oldCount = strongSelf.p_dataSource.count
                                    if let iterms: MeiziIterms = MeiziIterms.decodeJSON(from: response) {
                                        if iterms.results.count > 0 {
                                            strongSelf.p_dataSource.append(contentsOf: iterms.results)
                                        }
                                        else {
                                            strongSelf.p_hasMoreData = false
                                        }
                                    }
                                    if let succeed = suc {
                                        succeed(oldCount, strongSelf.p_dataSource)
                                    }
                                }
        }) { (error) in
            print("error = \(error)")
            if let failure = fail {
                failure(error)
            }
        }
    }
}
