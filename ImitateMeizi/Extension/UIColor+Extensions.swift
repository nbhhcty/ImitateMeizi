//
//  UIColor+Extensions.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/26.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(hex: String?) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    public convenience init(hex: String?, alpha a: Float? = 1) {
        if let ht = hex {
            var am : Float = 1.0
            if let at = a {
                am = at
            }
            var rgbValue : UInt32 = 0
            let scanner : Scanner = Scanner(string: ht)
            if ht.hasPrefix("#") {
                scanner.scanLocation = 1;
            } else if ht.hasPrefix("0x") || ht.hasPrefix("0X") {
                scanner.scanLocation = 2;
            } else {
                scanner.scanLocation = 0;
            }
            if scanner.scanHexInt32(&rgbValue) {
                self.init(red: CGFloat((rgbValue & 0xFF0000)>>16)/255.0 ,
                          green: CGFloat((rgbValue & 0x00FF00)>>8)/255.0 ,
                          blue: CGFloat((rgbValue & 0x0000FF))/255.0 ,
                          alpha: CGFloat(am))
            } else {
                self.init(red: 0, green: 0, blue: 0, alpha: CGFloat(am))
            }
        } else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
        }
    }
    
    open class var randomColor : UIColor {
        get{
            return UIColor(red: CGFloat(Float(arc4random() % 255) / 255.0),
                           green: CGFloat(Float(arc4random() % 255) / 255.0),
                           blue: CGFloat(Float(arc4random() % 255) / 255.0),
                           alpha: 1.0)
        }
    }
    
    /// Check if the color is in RGB format.
    ///
    /// - Returns: Returns if the color is in RGB format.
    public func canProvideRGBComponents() -> Bool {
        guard let colorSpace = cgColor.colorSpace else {
            return false
        }
        switch colorSpace.model {
        case CGColorSpaceModel.rgb, CGColorSpaceModel.monochrome:
            return true
        default:
            return false
        }
    }
    
    /// RGBA properties: alpha.
    public var alpha: CGFloat {
        return cgColor.alpha
    }
    
    #if canImport(UIKit)
    /// RGB properties: red.
    public var redComponent: CGFloat {
        guard canProvideRGBComponents(), let component = cgColor.__unsafeComponents else {
            return 0.0
        }
        
        return component[0]
    }
    
    /// RGB properties: green.
    public var greenComponent: CGFloat {
        guard canProvideRGBComponents(), let component = cgColor.__unsafeComponents else {
            return 0.0
        }
        
        guard cgColor.colorSpace?.model == CGColorSpaceModel.monochrome else {
            return component[1]
        }
        return component[0]
    }
    
    /// RGB properties: blue.
    public var blueComponent: CGFloat {
        guard canProvideRGBComponents(), let component = cgColor.__unsafeComponents else {
            return 0.0
        }
        
        guard cgColor.colorSpace?.model == CGColorSpaceModel.monochrome else {
            return component[2]
        }
        return component[0]
    }
    
    /// RGB properties: white.
    public var whiteComponent: CGFloat {
        guard cgColor.colorSpace?.model == CGColorSpaceModel.monochrome, let component = cgColor.__unsafeComponents else {
            return 0.0
        }
        
        return component[0]
    }
    #endif
}
