//
//  MeiziCellNode.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/30.
//  Copyright © 2018年 hml. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class MeiziCellNode: ASCellNode {
    private var p_imageNode: ASNetworkImageNode = ASNetworkImageNode.init()
    private var p_titleNode: ASTextNode = ASTextNode.init()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let titleInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        let titleInsetLayout: ASInsetLayoutSpec = ASInsetLayoutSpec.init(insets: titleInsets,
                                                                         child: self.p_titleNode)

        let titleRelativeLayout = ASRelativeLayoutSpec.init(horizontalPosition: .start,
                                                            verticalPosition: .end,
                                                            sizingOption: .minimumSize,
                                                            child: titleInsetLayout)

        let imageRatioLayout: ASRatioLayoutSpec = ASRatioLayoutSpec.init(ratio: 9/16,
                                                                         child: self.p_imageNode)

        let overLayout: ASOverlayLayoutSpec = ASOverlayLayoutSpec.init(child: imageRatioLayout,
                                                                       overlay: titleRelativeLayout)

        let contentInsets = UIEdgeInsets.init(top: 16, left: 16, bottom: 0, right: 16)
        let contentLayout: ASInsetLayoutSpec = ASInsetLayoutSpec.init(insets: contentInsets,
                                                                    child: overLayout)
        return contentLayout
    }
    
    convenience init(model: MeiziIterm) {
        self.init()
        // 添加图片
        self.p_imageNode = ASNetworkImageNode.initWith(url: model.thumb_url)
        self.p_imageNode.imageModificationBlock = self.p_imageNode.imageMaskScreenBlock()
        self.addSubnode(self.p_imageNode)
        
        // 添加文字
        self.p_titleNode = ASTextNode.initWith(attr: NSAttributedString.attributedStringForDescription(text: model.title))
        self.p_titleNode.tintColor = .white
        self.addSubnode(self.p_titleNode)
    }
    
    override init() {
        super.init()
    }
}
