//
//  Realm+Extension.swift
//  cache
//
//  Created by damien on 18/10/2022.
//

import Foundation
import RealmSwift

///
/// Extension for Array where Element is an Realm Object
///
extension Array where Element: Object {
    
    /// - Returns: Array into a RealmList
    public func toList() -> List<Element> {
        let result = List<Element>()
        self.forEach { element in result.append(element) }
        return result
    }
}

///
/// Extension for Array where Element is an Int
///
extension Array where Element == String {
    
    /// - Returns: Array into a RealmList
    public func toList() -> List<Element> {
        let result = List<Element>()
        self.forEach { element in result.append(element) }
        return result
    }
}

///
/// Extension for Dictionary where Element is an Int
///
extension Dictionary where Key: _MapKey, Value: RealmCollectionValue {

    /// - Returns: Dictionary into a RealmMap
    public func toMap() -> Map<Key, Value> {
        let result = Map<Key, Value>()
        self.forEach { key, value in
            result[key] = value
        }
        
        return result
    }
}

///
/// Extension for Map
///
public extension Map where Key: _MapKey, Value: RealmCollectionValue {
    
    /// - Returns: RealmMap into a Dictionary
    func toDictionary() -> [Key: Value] {
        var result: [Key : Value] = [:]
        
        self.forEach { element in  result[element.key] = element.value }
        return result
    }
}

///
/// Extension for RealmCollection where Element is Realm Object
///
public extension RealmCollection where Element: Object {

    /// - Returns: RealmCollection into a Swift Array
    func toArray() -> [Element] {
        return self.compactMap { $0 }
    }
    
    /// Property to check if RealmCollection is not empty
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

///
/// Extension for RealmCollection where Element is Int
///
public extension RealmCollection where Element == String {

    /// - Returns: RealmCollection into a Swift Array
    func toArray() -> [Element] {
        return self.compactMap { $0 }
    }
    
    /// Property to check if RealmCollection is not empty
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

public extension List {
    /// Property to check if List is not empty
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
