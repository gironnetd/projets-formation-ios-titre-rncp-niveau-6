//
//  Type.swift
//  designsystem
//
//  Created by damien on 14/12/2022.
//

import Foundation
import SwiftUI

protocol FontStyle: Hashable, RawRepresentable {
    var rawValue: String { get }
}

public class Typography {
    
    private enum Extension: String {
        case ttf
    }
    
    public class CustomFont {
        public let uiFont: UIFont
        let typeScaleTokens: TypeScaleTokens.Size
        var scaledMetric: CGFloat
        
        init(uiFont: UIFont, typeScaleTokens: TypeScaleTokens.Size, scaledMetric: CGFloat = 1.0) {
            self.uiFont = uiFont
            self.typeScaleTokens = typeScaleTokens
            self.scaledMetric = scaledMetric
        }
    }
    
    public enum Merriweather: RawRepresentable {
        
        public typealias RawValue = CustomFont
        
        public enum MerriweatherFontStyle: String, FontStyle {
            case black = "Merriweather-Black"
            case blackItalic = "Merriweather-BlackItalic"
            case bold = "Merriweather-Bold"
            case boldItalic = "Merriweather-BoldItalic"
            case italic = "Merriweather-Italic"
            case light = "Merriweather-Light"
            case lightItalic = "Merriweather-LightItalic"
            case regular = "Merriweather-Regular"
        }
        
        public init?(rawValue: RawValue) {
            switch rawValue.uiFont.fontName {
            case MerriweatherFontStyle.black.rawValue:
                self = .black(rawValue.typeScaleTokens)
            case MerriweatherFontStyle.blackItalic.rawValue:
                self = .blackItalic(rawValue.typeScaleTokens)
            case MerriweatherFontStyle.bold.rawValue:
                self = .bold(rawValue.typeScaleTokens)
            case MerriweatherFontStyle.boldItalic.rawValue:
                self = .boldItalic(rawValue.typeScaleTokens)
            case MerriweatherFontStyle.italic.rawValue:
                self = .italic(rawValue.typeScaleTokens)
            case MerriweatherFontStyle.light.rawValue:
                self = .light(rawValue.typeScaleTokens)
            case MerriweatherFontStyle.lightItalic.rawValue:
                self = .lightItalic(rawValue.typeScaleTokens)
            case MerriweatherFontStyle.regular.rawValue:
                self = .regular(rawValue.typeScaleTokens)
            default:
                self = .regular(TypeScaleTokens.Size.BodyMediumSize)
            }
        }
        
        case black(TypeScaleTokens.Size),
             blackItalic(TypeScaleTokens.Size),
             bold(TypeScaleTokens.Size),
             boldItalic(TypeScaleTokens.Size),
             italic(TypeScaleTokens.Size),
             light(TypeScaleTokens.Size),
             lightItalic(TypeScaleTokens.Size),
             regular(TypeScaleTokens.Size)
             
        public var rawValue: RawValue {
            switch self {
            case .black(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: MerriweatherFontStyle.black, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .blackItalic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: MerriweatherFontStyle.blackItalic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .bold(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: MerriweatherFontStyle.bold, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .boldItalic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: MerriweatherFontStyle.boldItalic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .italic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: MerriweatherFontStyle.italic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .light(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: MerriweatherFontStyle.light, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .lightItalic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: MerriweatherFontStyle.lightItalic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .regular(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: MerriweatherFontStyle.regular, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            }
        }
    }
    
    public enum PlayFairDisplay: RawRepresentable {
        
        public typealias RawValue = CustomFont
        
        public enum PlayFairDisplayFontStyle: String, FontStyle {
            case black = "PlayfairDisplay-Black"
            case blackItalic = "PlayfairDisplay-BlackItalic"
            case bold = "PlayfairDisplay-Bold"
            case boldItalic = "PlayfairDisplay-BoldItalic"
            case italic = "PlayfairDisplay-Italic"
            case medium = "PlayfairDisplay-Medium"
            case mediumItalic = "PlayfairDisplay-MediumItalic"
            case regular = "PlayfairDisplay-Regular"
            case semiBold = "PlayfairDisplay-SemiBold"
            case semiBoldItalic = "PlayfairDisplay-SemiBoldItalic"
        }
        
        case black(TypeScaleTokens.Size),
             blackItalic(TypeScaleTokens.Size),
             bold(TypeScaleTokens.Size),
             boldItalic(TypeScaleTokens.Size),
             italic(TypeScaleTokens.Size),
             medium(TypeScaleTokens.Size),
             mediumItalic(TypeScaleTokens.Size),
             regular(TypeScaleTokens.Size),
             semiBold(TypeScaleTokens.Size),
             semiBoldItalic(TypeScaleTokens.Size)
        
        public init?(rawValue: RawValue) {
            switch rawValue.uiFont.fontName {
            case PlayFairDisplayFontStyle.black.rawValue:
                self = .black(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.blackItalic.rawValue:
                self = .blackItalic(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.bold.rawValue:
                self = .bold(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.boldItalic.rawValue:
                self = .boldItalic(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.italic.rawValue:
                self = .italic(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.medium.rawValue:
                self = .medium(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.mediumItalic.rawValue:
                self = .mediumItalic(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.regular.rawValue:
                self = .regular(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.semiBold.rawValue:
                self = .semiBold(rawValue.typeScaleTokens)
            case PlayFairDisplayFontStyle.semiBoldItalic.rawValue:
                self = .semiBoldItalic(rawValue.typeScaleTokens)
            default:
                self = .regular(TypeScaleTokens.Size.BodyMediumSize)
            }
        }
        
        public var rawValue: RawValue {
            switch self {
            case .black(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.black, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .blackItalic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.blackItalic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .bold(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.bold, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .boldItalic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.boldItalic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .italic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.italic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .medium(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.medium, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .mediumItalic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.mediumItalic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .regular(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.regular, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .semiBold(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.semiBold, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            case .semiBoldItalic(let typeScaleTokens):
                return CustomFont(
                    uiFont: custom(fontStyle: PlayFairDisplayFontStyle.semiBoldItalic, typeScaleTokens: typeScaleTokens),
                    typeScaleTokens: typeScaleTokens)
            }
        }
    }
    
    internal static func custom<T: FontStyle>(fontStyle: T, typeScaleTokens: TypeScaleTokens.Size) -> UIFont {
        
        if let font = UIFont(name: fontStyle.rawValue, size: typeScaleTokens.rawValue) {
            return font
        }
        
        guard let asset = NSDataAsset(name: "fonts/\(fontStyle.rawValue)", bundle: Bundle.designsystem),
           let provider = CGDataProvider(data: asset.data as NSData),
           let font = CGFont(provider),
           CTFontManagerRegisterGraphicsFont(font, nil) else {
            fatalError("Couldn't create font from data")
        }
        
        return UIFont(name: fontStyle.rawValue, size: typeScaleTokens.rawValue) ?? .systemFont(ofSize: 17.0)
    }
}
