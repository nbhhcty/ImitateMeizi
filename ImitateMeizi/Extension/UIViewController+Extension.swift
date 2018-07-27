//
//  UIViewController+Extension.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/26.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    /// 控制器返回
    ///
    /// - Parameter animated: 动画展示
    func back(animated: Bool) {
        if let topVC = UIViewController.topViewController() {
            if let nav = topVC.navigationController {
                nav.popViewController(animated: animated)
            }
            else {
                self.dismiss(animated: animated, completion: nil)
            }
        }
    }
}
