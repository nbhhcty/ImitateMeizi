//
//  ASTextNode+Extension.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/31.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation
import AsyncDisplayKit

extension ASTextNode {
    class func initWith(attr: NSAttributedString) -> ASTextNode {
        return self.initWith(attr: attr, lineCount: 1)
    }
    
    class func initWith(attr: NSAttributedString, lineCount: Int) -> ASTextNode {
        let textNode: ASTextNode = ASTextNode.init()
        textNode.attributedText = attr
        textNode.placeholderEnabled = true
        textNode.placeholderFadeDuration = 0.2
        textNode.placeholderColor = UIColor.init(hex: "FFFFFF")
        textNode.maximumNumberOfLines = UInt(lineCount)
        textNode.truncationMode = .byTruncatingTail
        return textNode
    }
}
