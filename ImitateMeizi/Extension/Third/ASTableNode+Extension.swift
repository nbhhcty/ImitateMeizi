//
//  ASTableNode+Extension.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/31.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation
import AsyncDisplayKit

extension ASTableNode {
    func insertWith(start: Int, count:Int) {
        var indexPaths: [IndexPath] = []
        for row in start ..< count {
            let indexPath = IndexPath.init(row: row, section: 0)
            indexPaths.append(indexPath)
        }
        self.insertRows(at: indexPaths, with: .none)
    }
}
