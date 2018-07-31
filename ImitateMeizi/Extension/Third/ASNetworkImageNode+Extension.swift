//
//  ASNetworkImageNode+Extension.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/31.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation
import AsyncDisplayKit

extension ASNetworkImageNode {
    class func initWith(url: String) -> ASNetworkImageNode {
        let imageNode = ASNetworkImageNode.init()
        imageNode.url = url.url
        imageNode.clipsToBounds = true
        imageNode.placeholderFadeDuration = 0.2
        imageNode.placeholderEnabled = true
        imageNode.contentMode = .scaleAspectFill
        return imageNode
    }
    
    func imageMaskScreenBlock() -> asimagenode_modification_block_t {
        return self.imageModBlockWith(corner: 8, maskImage: UIImage.init(named: "mask_smallscreen"))
    }
    
    func imageMaskScreenBlock(corner: CGFloat) -> asimagenode_modification_block_t {
        return self.imageModBlockWith(corner: corner, maskImage: nil)
    }
    
    func imageModBlockWith(corner: CGFloat, maskImage: UIImage?) -> asimagenode_modification_block_t {
        return { [weak self](inImage: UIImage) -> UIImage? in
            if let strongSelf = self {
                let size: CGSize = CGSize.init(width: strongSelf.calculatedSize.width*UIScreen.main.scale,
                                               height: strongSelf.calculatedSize.height*UIScreen.main.scale)
                UIGraphicsBeginImageContext(size)
                let path = UIBezierPath.init(roundedRect: CGRect.init(x: 0,
                                                                      y: 0,
                                                                      width: size.width,
                                                                      height: size.height),
                                             cornerRadius: corner*UIScreen.main.scale)
                path.addClip()
                inImage.draw(in: CGRect.init(x: 0,
                                             y: 0,
                                             width: size.width,
                                             height: size.height))
                if let maskImage = maskImage {
                    maskImage.draw(in: CGRect.init(x: 0,
                                                   y: 0,
                                                   width: size.width,
                                                   height: size.height))
                }
                let refinedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                return refinedImage
            }
            else {
                return nil
            }
        }
    }
}
