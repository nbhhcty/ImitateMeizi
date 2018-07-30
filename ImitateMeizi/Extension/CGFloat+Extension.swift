//
//  CGfloat+Extension.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/30.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    
    static func ratioWidthOf375(value: CGFloat) -> CGFloat {
        return value * CGFloat.screen_width_small / 375.0
    }
    
    static func ratioHeightOf667(value: CGFloat) -> CGFloat {
        return value * CGFloat.screen_height / 667.0
    }
    
    static var screen_width_small: CGFloat {
        get {
            let rect = UIScreen.main.bounds
            return  rect.width < rect.height ? rect.width : rect.height
        }
    }
    
    static var screen_width_large: CGFloat {
        get {
            let rect = UIScreen.main.bounds
            return  rect.width > rect.height ? rect.width : rect.height
        }
    }
    
    static var screen_height: CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
    
    static var screen_width: CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    static var statusBarHeight: CGFloat {
        get {
            if Bool.isiPhoneX {
                return 44
            } else {
                return 20
            }
        }
    }
    
    static var gamePlayViewHeight: CGFloat {
        get {
            return CGFloat.screen_width_small * 9 / 16.0
        }
    }
    static var suiPaiPlayViewHeight: CGFloat {
        get {
            return CGFloat.screen_width_small * 3 / 4.0
        }
    }
}
