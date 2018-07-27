//
//  Data+Extensions.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/26.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation

// MARK: - Data extension
/// This extension add some useful functions to Data.
public extension Data {
    // MARK: - Functions
    
    /// Convert self to a UTF8 String.
    ///
    /// - Returns: Returns self as UTF8 NSString.
    public func utf8() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// Convert self to a ASCII String.
    ///
    /// - Returns: Returns self as ASCII String.
    public func ascii() -> String? {
        return String(data: self, encoding: .ascii)
    }
    
    /// Convert self UUID to String.
    ///
    /// Useful for push notifications.
    ///
    /// - Returns: Returns self as String from UUID.
    public func readableUUID() -> String {
        return description.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }
}
