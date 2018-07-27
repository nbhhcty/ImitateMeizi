//
//  Array+Extension.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/26.
//  Copyright © 2018年 hml. All rights reserved.
//

import Foundation

extension Array {
    
    /// 去重
    /// 使用：arr.filterDuplicates({ $0.user.uid})
    /// - Parameter filter:
    /// - Returns:
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

// MARK: - Global functions
/// Creates a flatten array.
///
/// Example:
///
///     [1, 2, [3, [4]]] -> [1, 2, 3, 4]
///
/// - Parameter array: Array bo te flattened.
/// - Returns: Returns a flatten array.
public func flatten<T>(_ array: [T]) -> [T] {
    /// Returned flattened array.
    var flattened: [T] = []
    
    /// For every element inside the array.
    for element in array {
        /// If it's a nested array, safely cast.
        if let subarray = element as? [T] {
            /// For every subarray call the `flatten` function.
            for subelement in flatten(subarray) {
                /// We are now sure that this is an element
                /// and we can add it to `flattened`.
                flattened.append(subelement)
            }
        } else {
            /// Otherwise is an element and add it to `flattened`.
            flattened.append(element)
        }
    }
    
    return flattened
}

// MARK: - Array extension
/// This extension adds some useful functions to Array.
public extension Array {
    // MARK: - Functions
    
    /// A Bool value indicating whether the collection is not empty.
    ///
    /// - Returns: Returns a Bool value indicating whether the collection is not empty.
    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// Simulates the array as a circle. When it is out of range, begins again.
    ///
    /// - Parameter index: The index.
    /// - Returns: Returns the object at a given index.
    public func circleObject(at index: Int) -> Element {
        return self[superCircle(at: index, size: count)]
    }
    
    /// Randomly selects an element from self and returns it.
    ///
    /// - returns: An element that was randomly selected from the array.
    public func random() -> Element {
        return self[randomInt(range: 0...count - 1)]
    }
    
    /// Removes the element from self that is passed in.
    ///
    /// - parameter object: The element that is removed from
    public mutating func remove(_ object: Element) {
        var array: [String] = []
        for index in self {
            array.append("\(index)")
        }
        let index = array.index(of: "\(object)")
        if let index = index {
            remove(at: index)
        }
    }
    
    /// Get the object at a given index in safe mode (nil if self is empty or out of range).
    ///
    /// - Parameter index: The index.
    /// - Returns: Returns the object at a given index in safe mode (nil if self is empty or out of range).
    public func safeObject(at index: Int) -> Element? {
        guard !isEmpty, count > index else {
            return nil
        }
        
        return self[index]
    }
    
    /// Get the index as a circle.
    ///
    /// - Parameters:
    ///   - index: The index.
    ///   - maxSize: Max size of the array.
    /// - Returns: Returns the right index.
    private func superCircle(at index: Int, size maxSize: Int) -> Int {
        var newIndex = index
        if newIndex < 0 {
            newIndex = newIndex % maxSize
            newIndex += maxSize
        }
        if newIndex >= maxSize {
            newIndex = newIndex % maxSize
        }
        
        return newIndex
    }
    
    /// Move object from an index to another.
    ///
    /// - Parameters:
    ///   - fromIndex: The start index.
    ///   - toIndex: The end index.
    public mutating func swap(from fromIndex: Int, to toIndex: Int) {
        if toIndex != fromIndex {
            guard let object: Element = safeObject(at: fromIndex) else {
                return
            }
            remove(at: fromIndex)
            
            if toIndex >= count {
                append(object)
            } else {
                insert(object, at: toIndex)
            }
        }
    }
    
    /// Shuffle the elements of `self` in-place.
    public mutating func shuffle() {
        for index in 0..<(count - 1) {
            let newIndex = Int(randomInt(range: 0...Int(count - index))) + index
            swap(from: index, to: newIndex)
        }
    }
    
    /// Return a copy of self with its elements shuffled.
    ///
    /// - Returns: Return a copy of `self` with its elements shuffled.
    public func shuffled() -> [Element] {
        var list = self
        list.shuffle()
        return list
    }
}
