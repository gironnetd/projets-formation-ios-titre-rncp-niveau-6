//
//  TypographyTokens.swift
//  designsystem
//
//  Created by damien on 20/12/2022.
//

import Foundation
import SwiftUI

///
/// Structure inherited TextStyle Protocol
///
public struct AnyTextStyle: TextStyle {
    
    public var customFont: Typography.CustomFont
    public var fontColor: UIColor
    public var fontSize: TypeScaleTokens.Size
    public var scaledMetric: CGFloat = 1.0
    public var lineHeight: TypeScaleTokens.LineHeight
    public var letterSpacing: TypeScaleTokens.Tracking
    
    public init() {
        self.customFont = Typography.CustomFont(
            uiFont: Typography.custom(fontStyle: Typography.PlayFairDisplay.PlayFairDisplayFontStyle.medium, typeScaleTokens: TypeScaleTokens.Size.BodyMediumSize),
            typeScaleTokens: TypeScaleTokens.Size.BodyMediumSize)
        self.fontColor = UIColor.black
        self.fontSize =  TypeScaleTokens.Size.BodyMediumSize
        self.lineHeight = TypeScaleTokens.LineHeight.BodyMediumLineHeight
        self.letterSpacing = TypeScaleTokens.Tracking.BodyMediumTracking
    }
    
    public init(customFont: Typography.CustomFont,
                fontColor: UIColor = UIColor.black,
                fontSize: TypeScaleTokens.Size,
                scaledMetric: CGFloat = 1.0,
                lineHeight: TypeScaleTokens.LineHeight,
                letterSpacing: TypeScaleTokens.Tracking) {
        self.customFont = customFont
        self.fontColor = fontColor
        self.fontSize = fontSize
        self.scaledMetric = scaledMetric
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }
}

///
/// Class for Typography tokens in application
///
public class TypographyTokens {
    
    public static var BodyLarge
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.BodyLargeSize),
                        typeScaleTokens: TypeScaleTokens.Size.BodyLargeSize),
                       fontSize: TypeScaleTokens.Size.BodyLargeSize,
                       lineHeight: TypeScaleTokens.LineHeight.BodyLargeLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.BodyLargeTracking)
    
    public static var BodyMedium
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.PlayFairDisplay.PlayFairDisplayFontStyle.medium, typeScaleTokens: TypeScaleTokens.Size.BodyMediumSize),
                        typeScaleTokens: TypeScaleTokens.Size.BodyMediumSize),
                       fontSize: TypeScaleTokens.Size.BodyMediumSize,
                       lineHeight: TypeScaleTokens.LineHeight.BodyMediumLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.BodyMediumTracking)
    
    public static var BodySmall
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.BodySmallSize),
                        typeScaleTokens: TypeScaleTokens.Size.BodySmallSize),
                       fontSize: TypeScaleTokens.Size.BodySmallSize,
                       lineHeight: TypeScaleTokens.LineHeight.BodySmallLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.BodySmallTracking)
    
    public static var DisplayLarge
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.black, typeScaleTokens: TypeScaleTokens.Size.DisplayLargeSize),
                        typeScaleTokens: TypeScaleTokens.Size.DisplayLargeSize),
                       fontSize: TypeScaleTokens.Size.DisplayLargeSize,
                       lineHeight: TypeScaleTokens.LineHeight.DisplayLargeLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.DisplayLargeTracking)
    
    public static var DisplayMedium
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.DisplayMediumSize),
                        typeScaleTokens: TypeScaleTokens.Size.DisplayMediumSize),
                       fontSize: TypeScaleTokens.Size.DisplayMediumSize,
                       lineHeight: TypeScaleTokens.LineHeight.DisplayMediumLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.DisplayMediumTracking)
    
    public static var DisplaySmall
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.DisplaySmallSize),
                        typeScaleTokens: TypeScaleTokens.Size.DisplaySmallSize),
                       fontSize: TypeScaleTokens.Size.DisplaySmallSize,
                       lineHeight: TypeScaleTokens.LineHeight.DisplaySmallLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.DisplaySmallTracking)

    public static var HeadlineLarge
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.HeadlineLargeSize),
                        typeScaleTokens: TypeScaleTokens.Size.HeadlineLargeSize),
                       fontSize: TypeScaleTokens.Size.HeadlineLargeSize,
                       lineHeight: TypeScaleTokens.LineHeight.HeadlineLargeLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.HeadlineLargeTracking)
    
    public static var HeadlineMedium
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.HeadlineMediumSize),
                        typeScaleTokens: TypeScaleTokens.Size.HeadlineMediumSize),
                       fontSize: TypeScaleTokens.Size.HeadlineMediumSize,
                       lineHeight: TypeScaleTokens.LineHeight.HeadlineMediumLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.HeadlineMediumTracking)
    
    public static var HeadlineSmall
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.HeadlineSmallSize),
                        typeScaleTokens: TypeScaleTokens.Size.HeadlineSmallSize),
                       fontSize: TypeScaleTokens.Size.HeadlineSmallSize,
                       lineHeight: TypeScaleTokens.LineHeight.HeadlineSmallLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.HeadlineSmallTracking)
    
    public static var LabelLarge
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.LabelLargeSize),
                        typeScaleTokens: TypeScaleTokens.Size.LabelLargeSize),
                       fontSize: TypeScaleTokens.Size.LabelLargeSize,
                       lineHeight: TypeScaleTokens.LineHeight.LabelLargeLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.LabelLargeTracking)
    
    public static var LabelMedium
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.regular, typeScaleTokens: TypeScaleTokens.Size.LabelMediumSize),
                        typeScaleTokens: TypeScaleTokens.Size.LabelMediumSize),
                       fontSize: TypeScaleTokens.Size.LabelMediumSize,
                       lineHeight: TypeScaleTokens.LineHeight.LabelMediumLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.LabelMediumTracking)
    
    public static var LabelSmall
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.regular, typeScaleTokens: TypeScaleTokens.Size.LabelSmallSize),
                        typeScaleTokens: TypeScaleTokens.Size.LabelSmallSize),
                       fontSize: TypeScaleTokens.Size.LabelSmallSize,
                       lineHeight: TypeScaleTokens.LineHeight.LabelSmallLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.LabelSmallTracking)
    
    public static var TitleLarge
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.TitleLargeSize),
                        typeScaleTokens: TypeScaleTokens.Size.TitleLargeSize),
                       fontSize: TypeScaleTokens.Size.TitleLargeSize,
                       lineHeight: TypeScaleTokens.LineHeight.TitleLargeLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.TitleLargeTracking)
    
    public static var TitleMedium
        = AnyTextStyle(customFont: Typography.CustomFont(
            uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.bold, typeScaleTokens: TypeScaleTokens.Size.TitleMediumSize),
                        typeScaleTokens: TypeScaleTokens.Size.TitleMediumSize),
                       fontSize: TypeScaleTokens.Size.TitleMediumSize,
                       lineHeight: TypeScaleTokens.LineHeight.TitleMediumLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.TitleMediumTracking)
    
    public static var TitleSmall
        = AnyTextStyle(customFont: Typography.CustomFont(
                        uiFont: Typography.custom(fontStyle: Typography.Merriweather.MerriweatherFontStyle.regular, typeScaleTokens: TypeScaleTokens.Size.TitleSmallSize),
                        typeScaleTokens: TypeScaleTokens.Size.TitleSmallSize),
                       fontSize: TypeScaleTokens.Size.TitleSmallSize,
                       lineHeight: TypeScaleTokens.LineHeight.TitleSmallLineHeight,
                       letterSpacing: TypeScaleTokens.Tracking.TitleSmallTracking)
}
