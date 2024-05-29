//
//  DataFactory.swift
//  util
//
//  Created by damien on 15/09/2022.
//

import Foundation

///
/// Class intended to provide random data
///
public class DataFactory {
    
    /// Function to provide a random email
    ///
    /// - Returns: A random email
    public static func randomEmail() -> String {
        let nameLength = randomInt(from: 5, to: 10)
        let domainLength = randomInt(from: 5, to: 10)
        let domainSuffixes = ["com", "net", "org", "io", "co.uk"]
        let name = randomText(length: nameLength, justLowerCase: true)
        let domain = randomText(length: domainLength, justLowerCase: true)
        let randomDomainSuffixIndex = Int(arc4random_uniform(UInt32(domainSuffixes.count)))
        let domainSuffix = domainSuffixes[randomDomainSuffixIndex]
        let text = name + "@" + domain + "." + domainSuffix
        return text
    }
    
    /// Function to provide a random Int in a given range
    /// - Parameters:
    ///   - from: The starting integer
    ///   - to: The end integer
    /// - Returns: A random Int
    private static func randomInt(from: Int, to: Int) -> Int {
        let range = UInt32(to - from)
        let rndInt = Int(arc4random_uniform(range + 1)) + from
        return rndInt
    }
    
    /// Function to provide a random Text
    /// - Parameters:
    ///    - length: The lenght of the Text
    ///    - justLowerCase: a Boolean to specify whether the text should be lowercase
    /// - Returns: A random Text
    private static func randomText(length: Int, justLowerCase: Bool = false) -> String {
        var text = ""
        for _ in 1...length {
            var decValue = 0  // ascii decimal value of a character
            var charType = 3  // default is lowercase
            if justLowerCase == false {
                // randomize the character type
                charType =  Int(arc4random_uniform(4))
            }
            switch charType {
            case 1:  // digit: random Int between 48 and 57
                decValue = Int(arc4random_uniform(10)) + 48
            case 2:  // uppercase letter
                decValue = Int(arc4random_uniform(26)) + 65
            case 3:  // lowercase letter
                decValue = Int(arc4random_uniform(26)) + 97
            default:  // space character
                decValue = 32
            }
            // get ASCII character from random decimal value
            let char = String(UnicodeScalar(decValue)!)
            text += char
            // remove double spaces
            text = text.replacingOccurrences(of: "  ", with: " ")
        }
        return text
    }
    
    /// Function to provide a random Int
    /// - Returns: A random Int
    public static func randomInt() -> Int {
        return Int.random(in: 0...Int.max)
    }
    
    /// Function to provide a random String
    /// - Returns: A random String
    public static func randomString() -> String {
        return UUID().uuidString
    }
    
    /// Function to provide a random Boolean
    /// - Returns: A random Boolean
    public static func randomBoolean() -> Bool {
        return Bool.random()
    }
    
    /// Function to provide a random Data
    /// - Returns: A random Data
    public static func randomData() -> Data {
        return randomText(length: 5).data(using: .utf8)!
    }
}
