//
//  Bool+Extension.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/30.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation
import UIKit

extension Bool {
    static var isiPhoneX: Bool {
        get {
            let str = UIDevice.detailedModel
            return str == "iPhone X"
        }
    }
    
    static var isPortrait:Bool {
        get {
            return !UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        }
    }
}
