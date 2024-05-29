//
//  UIDevice+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 13/02/2023.
//

import UIKit

///
/// Extension for UIDevice Class
///
public extension UIDevice {
    
    /// Variable allowing to know on which terminal model the application is used
    static let model: Model = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        ///
        /// Function return the ``Model``of the Device
        /// - Parameters:
        ///    - identifier: The identifier of the Device
        /// - Returns: The ``Model`` of the Device
        func mapToDevice(identifier: String) -> Model { // swiftlint:disable:this cyclomatic_complexity
#if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return .iPod5
            case "iPod7,1":                                       return .iPod6
            case "iPod9,1":                                       return .iPod7
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return .iPhone4
            case "iPhone4,1":                                     return .iPhone4S
            case "iPhone5,1", "iPhone5,2":                        return .iPhone5
            case "iPhone5,3", "iPhone5,4":                        return .iPhone5C
            case "iPhone6,1", "iPhone6,2":                        return .iPhone5S
            case "iPhone7,2":                                     return .iPhone6
            case "iPhone7,1":                                     return .iPhone6Plus
            case "iPhone8,1":                                     return .iPhone6S
            case "iPhone8,2":                                     return .iPhone6SPlus
            case "iPhone9,1", "iPhone9,3":                        return .iPhone7
            case "iPhone9,2", "iPhone9,4":                        return .iPhone7Plus
            case "iPhone10,1", "iPhone10,4":                      return .iPhone8
            case "iPhone10,2", "iPhone10,5":                      return .iPhone8Plus
            case "iPhone10,3", "iPhone10,6":                      return .iPhoneX
            case "iPhone11,2":                                    return .iPhoneXS
            case "iPhone11,4", "iPhone11,6":                      return .iPhoneXSMax
            case "iPhone11,8":                                    return .iPhoneXR
            case "iPhone12,1":                                    return .iPhone11
            case "iPhone12,3":                                    return .iPhone11Pro
            case "iPhone12,5":                                    return .iPhone11ProMax
            case "iPhone13,1":                                    return .iPhone12Mini
            case "iPhone13,2":                                    return .iPhone12
            case "iPhone13,3":                                    return .iPhone12Pro
            case "iPhone13,4":                                    return .iPhone12ProMax
            case "iPhone14,4":                                    return .iPhone13Mini
            case "iPhone14,5":                                    return .iPhone13
            case "iPhone14,2":                                    return .iPhone13Pro
            case "iPhone14,3":                                    return .iPhone13ProMax
            case "iPhone14,7":                                    return .iPhone14
            case "iPhone14,8":                                    return .iPhone14Plus
            case "iPhone15,2":                                    return .iPhone14Pro
            case "iPhone15,3":                                    return .iPhone14ProMax
            case "iPhone8,4":                                     return .iPhoneSE
            case "iPhone12,8":                                    return .iPhoneSE2
            case "iPhone14,6":                                    return .iPhoneSE3
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return .iPad2
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return .iPad3
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return .iPad4
            case "iPad6,11", "iPad6,12":                          return .iPad5
            case "iPad7,5", "iPad7,6":                            return .iPad6
            case "iPad7,11", "iPad7,12":                          return .iPad7
            case "iPad11,6", "iPad11,7":                          return .iPad8
            case "iPad12,1", "iPad12,2":                          return .iPad9
            case "iPad13,18", "iPad13,19":                        return .iPad9
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return .iPadAir
            case "iPad5,3", "iPad5,4":                            return .iPadAir2
            case "iPad11,3", "iPad11,4":                          return .iPadAir3
            case "iPad13,1", "iPad13,2":                          return .iPadAir4
            case "iPad13,16", "iPad13,17":                        return .iPadAir5
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return .iPadMini
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return .iPadMini2
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return .iPadMini3
            case "iPad5,1", "iPad5,2":                            return .iPadMini4
            case "iPad11,1", "iPad11,2":                          return .iPadMini5
            case "iPad14,1", "iPad14,2":                          return .iPadMini6
            case "iPad6,3", "iPad6,4":                            return .iPadPro9_7
            case "iPad7,3", "iPad7,4":                            return .iPadPro10_5
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return .iPadPro11
            case "iPad8,9", "iPad8,10":                           return .iPadPro2_11
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return .iPadPro3_11
            case "iPad14,3", "iPad14,4":                          return .iPadPro4_11
            case "iPad6,7", "iPad6,8":                            return .iPadPro12_9
            case "iPad7,1", "iPad7,2":                            return .iPadPro2_12_9
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return .iPadPro3_12_9
            case "iPad8,11", "iPad8,12":                          return .iPadPro4_12_9
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return .iPadPro5_12_9
            case "iPad14,5", "iPad14,6":                          return .iPadPro6_12_9
            case "AppleTV5,3":                                    return .AppleTV1
            case "AppleTV6,2":                                    return .AppleTV_4K
            case "AudioAccessory1,1":                             return .HomePod
            case "AudioAccessory5,1":                             return .HomePodMini
            case "i386", "x86_64", "arm64":                       return mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS")
            default:                                              return .unrecognized
            }
#elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return .AppleTV4
            case "AppleTV6,2": return .AppleTV_4K
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return .unrecognized
            }
#endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}

///
/// Enum representing the model of the Device
///
public enum Model : String {
    case iPod5 = "iPod touch (5th generation)",
         iPod6 = "iPod touch (6th generation)",
         iPod7 = "iPod touch (7th generation)",
         iPhone4 = "iPhone 4",
         iPhone4S = "iPhone 4s",
         iPhone5 = "iPhone 5",
         iPhone5C = "iPhone 5c",
         iPhone5S = "iPhone 5s",
         iPhone6 = "iPhone 6",
         iPhone6Plus = "iPhone 6 Plus",
         iPhone6S = "iPhone 6s",
         iPhone6SPlus = "iPhone 6s Plus",
         iPhone7 = "iPhone 7",
         iPhone7Plus = "iPhone 7 Plus",
         iPhone8 = "iPhone 8",
         iPhone8Plus = "iPhone 8 Plus",
         iPhoneX = "iPhone X",
         iPhoneXS = "iPhone XS",
         iPhoneXSMax = "iPhone XS Max",
         iPhoneXR = "iPhone XR",
         iPhone11 = "iPhone 11",
         iPhone11Pro = "iPhone 11 Pro",
         iPhone11ProMax = "iPhone 11 Pro Max",
         iPhone12Mini = "iPhone 12 mini",
         iPhone12 = "iPhone 12",
         iPhone12Pro = "iPhone 12 Pro",
         iPhone12ProMax = "iPhone 12 Pro Max",
         iPhone13Mini = "iPhone 13 mini",
         iPhone13 = "iPhone 13",
         iPhone13Pro = "iPhone 13 Pro",
         iPhone13ProMax = "iPhone 13 Pro Max",
         iPhone14 = "iPhone 14",
         iPhone14Plus = "iPhone 14 Plus",
         iPhone14Pro = "iPhone 14 Pro",
         iPhone14ProMax = "iPhone 14 Pro Max",
         iPhoneSE = "iPhone SE",
         iPhoneSE2 = "iPhone SE (2nd generation)",
         iPhoneSE3 = "iPhone SE (3rd generation)",
         iPad2 = "iPad 2",
         iPad3 = "iPad (3rd generation)",
         iPad4 = "iPad (4th generation)",
         iPad5 = "iPad (5th generation)",
         iPad6 = "iPad (6th generation)",
         iPad7 = "iPad (7th generation)",
         iPad8 = "iPad (8th generation)",
         iPad9 = "iPad (9th generation)",
         iPad10 = "iPad (10th generation)",
         iPadAir = "iPad Air",
         iPadAir2 = "iPad Air 2",
         iPadAir3 = "iPad Air (3rd generation)",
         iPadAir4 = "iPad Air (4th generation)",
         iPadAir5 = "iPad Air (5th generation)",
         iPadMini = "iPad mini",
         iPadMini2 = "iPad mini 2",
         iPadMini3 = "iPad mini 3",
         iPadMini4 = "iPad mini 4",
         iPadMini5 = "iPad mini (5th generation)",
         iPadMini6 = "iPad mini (6th generation)",
         iPadPro9_7 = "iPad Pro (9.7-inch)",
         iPadPro10_5 = "iPad Pro (10.5-inch)",
         iPadPro11 = "iPad Pro (11-inch) (1st generation)",
         iPadPro2_11 = "iPad Pro (11-inch) (2nd generation)",
         iPadPro3_11 = "iPad Pro (11-inch) (3rd generation)",
         iPadPro4_11 = "iPad Pro (11-inch) (4th generation)",
         iPadPro12_9 = "iPad Pro (12.9-inch) (1st generation)",
         iPadPro2_12_9 = "iPad Pro (12.9-inch) (2nd generation)",
         iPadPro3_12_9 = "iPad Pro (12.9-inch) (3rd generation)",
         iPadPro4_12_9 = "iPad Pro (12.9-inch) (4th generation)",
         iPadPro5_12_9 = "iPad Pro (12.9-inch) (5th generation)",
         iPadPro6_12_9 = "iPad Pro (12.9-inch) (6th generation)",
         
         HomePod = "HomePod",
         HomePodMini = "HomePod mini",
         
         simulator     = "simulator/sandbox",
         
         AppleWatch1         = "Apple Watch 1gen",
         AppleWatchS1        = "Apple Watch Series 1",
         AppleWatchS2        = "Apple Watch Series 2",
         AppleWatchS3        = "Apple Watch Series 3",
         AppleWatchS4        = "Apple Watch Series 4",
         AppleWatchS5        = "Apple Watch Series 5",
         AppleWatchSE        = "Apple Watch Special Edition",
         AppleWatchS6        = "Apple Watch Series 6",
         AppleWatchS7        = "Apple Watch Series 7",
         
         AppleTV1 = "Apple TV",
         AppleTV2           = "Apple TV 2gen",
         AppleTV3           = "Apple TV 3gen",
         AppleTV4           = "Apple TV 4gen",
         AppleTV_4K = "Apple TV 4K",
         AppleTV2_4K        = "Apple TV 4K 2gen",
         
         unrecognized       = "unrecognized"
}
