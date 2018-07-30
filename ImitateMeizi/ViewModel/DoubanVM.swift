//
//  DoubanVM.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/30.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation

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

    func loadData() {
        DoubanNetwork.request(target: .category("All", self.p_curPage),
                              success: { [weak self] (response) in
                                if let strongSelf = self {
                                    strongSelf.p_curPage = strongSelf.p_curPage + 1
                                    if let iterms: MeiziIterms = MeiziIterms.decodeJSON(from: response) {
                                        if iterms.results.count > 0 {
                                            strongSelf.p_dataSource.append(contentsOf: iterms.results)
                                        }
                                        else {
                                            strongSelf.p_hasMoreData = false
                                        }
                                    }
                                }
        }) { (error) in
            print("error = \(error)")
        }
    }
}
