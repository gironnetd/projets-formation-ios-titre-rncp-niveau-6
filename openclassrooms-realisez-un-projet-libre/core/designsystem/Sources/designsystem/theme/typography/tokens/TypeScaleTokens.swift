//
//  TypeScaleTokens.swift
//  designsystem
//
//  Created by damien on 20/12/2022.
//

import Foundation
import SwiftUI
import common

///
/// Class for TypeScale tokens in application
///
public class TypeScaleTokens {
    
    public static var horizontalSizeClass: UIUserInterfaceSizeClass = UIScreen.main.traitCollection.horizontalSizeClass
    public static var verticalSizeClass: UIUserInterfaceSizeClass = UIScreen.main.traitCollection.verticalSizeClass
    
    public enum LineHeight {
        case BodyLargeLineHeight, TitleMediumLineHeight
        case BodyMediumLineHeight, LabelLargeLineHeight, TitleSmallLineHeight
        case BodySmallLineHeight, LabelMediumLineHeight, LabelSmallLineHeight
        case DisplayLargeLineHeight
        case DisplayMediumLineHeight
        case DisplaySmallLineHeight
        case HeadlineLargeLineHeight
        case HeadlineMediumLineHeight
        case HeadlineSmallLineHeight
        case TitleLargeLineHeight
        
        public var rawValue: CGFloat {
            switch self {
            case .BodyLargeLineHeight: return CGFloat(isTablet ? 26.0 : 24.0).adjustFontLineHeight()
            case .BodyMediumLineHeight: return CGFloat(isTablet ? 26.0 : 24.0).adjustFontLineHeight()
            case .BodySmallLineHeight: return CGFloat(isTablet ? 16.0 : 16.0).adjustFontLineHeight()
            case .DisplayLargeLineHeight: return CGFloat(isTablet ? 64.0 : 64.0).adjustFontLineHeight()
            case .DisplayMediumLineHeight: return CGFloat(isTablet ? 52.0 : 52.0).adjustFontLineHeight()
            case .DisplaySmallLineHeight: return CGFloat(isTablet ? 46.0 : 44.0).adjustFontLineHeight()
            case .HeadlineLargeLineHeight: return CGFloat(isTablet ? 40.0 : 40.0).adjustFontLineHeight()
            case .HeadlineMediumLineHeight: return CGFloat(isTablet ? 36.0 : 36.0).adjustFontLineHeight()
            case .HeadlineSmallLineHeight: return CGFloat(isTablet ? 32.0 : 32.0).adjustFontLineHeight()
            case .LabelLargeLineHeight: return CGFloat(isTablet ? 23.0 : 20.0).adjustFontLineHeight()
            case .LabelMediumLineHeight: return CGFloat(isTablet ? 16.0 : 16.0).adjustFontLineHeight()
            case .LabelSmallLineHeight: return CGFloat(isTablet ? 16.0 : 16.0).adjustFontLineHeight()
            case .TitleLargeLineHeight: return CGFloat(isTablet ? 28.0 : 28.0).adjustFontLineHeight()
            case .TitleMediumLineHeight: return CGFloat(isTablet ? 28.0 : 22.0).adjustFontLineHeight()
            case .TitleSmallLineHeight: return CGFloat(isTablet ? 23.0 : 20.0).adjustFontLineHeight()
            }
        }
    }
    
    public enum Size {
        
        case TitleMediumSize, BodyLargeSize
        case BodyMediumSize, LabelLargeSize, TitleSmallSize
        case BodySmallSize, LabelMediumSize
        case DisplayLargeSize
        case DisplayMediumSize
        case DisplaySmallSize
        case HeadlineLargeSize
        case HeadlineMediumSize
        case HeadlineSmallSize
        case LabelSmallSize
        case TitleLargeSize
        
        public var rawValue: CGFloat {
            switch self {
            case .BodyLargeSize: return CGFloat(isTablet ? 18.0 : 16.0).adjustFontSize()
            case .BodyMediumSize: return CGFloat(isTablet ? 18.0 : 16.0).adjustFontSize()
            case .BodySmallSize: return CGFloat(isTablet ? 16.0 : 16.0).adjustFontSize()
            case .DisplayLargeSize: return CGFloat(isTablet ? 57.0 : 57.0).adjustFontSize()
            case .DisplayMediumSize: return CGFloat(isTablet ? 45.0 : 45.0).adjustFontSize()
            case .DisplaySmallSize: return CGFloat(isTablet ? 46.0 : 36.0).adjustFontSize()
            case .HeadlineLargeSize: return CGFloat(isTablet ? 32.0 : 32.0).adjustFontSize()
            case .HeadlineMediumSize: return CGFloat(isTablet ? 24.0 : 24.0).adjustFontSize()
            case .HeadlineSmallSize: return CGFloat(isTablet ? 19.0 : 19.0).adjustFontSize()
            case .LabelLargeSize: return CGFloat(isTablet ? 17.0 : 14.0).adjustFontSize()
            case .LabelMediumSize: return CGFloat(isTablet ? 12.0 : 12.0).adjustFontSize()
            case .LabelSmallSize: return CGFloat(isTablet ? 11.0 : 11.0).adjustFontSize()
            case .TitleLargeSize: return CGFloat(isTablet ? 22.0 : 22.0).adjustFontSize()
            case .TitleMediumSize: return CGFloat(isTablet ? 21.0 : 21.0).adjustFontSize()
            case .TitleSmallSize: return CGFloat(isTablet ? 17.0 : 14.0).adjustFontSize()
            }
        }
    }
    
    public enum Tracking {
        case BodyLargeTracking, LabelMediumTracking, LabelSmallTracking, BodyMediumTracking, TitleMediumTracking,
             BodySmallTracking, DisplayLargeTracking, DisplayMediumTracking,
             TitleLargeTracking, DisplaySmallTracking, HeadlineLargeTracking,
             HeadlineMediumTracking, HeadlineSmallTracking, LabelLargeTracking, TitleSmallTracking

        var rawValue: CGFloat {
            switch self {
            case .BodyLargeTracking, .LabelMediumTracking, .LabelSmallTracking: return 0.5
            case .BodyMediumTracking, .TitleMediumTracking: return 0.2
            case .BodySmallTracking: return 0.4
            case .DisplayLargeTracking: return -0.2
            case .DisplayMediumTracking, .TitleLargeTracking, .DisplaySmallTracking,
                    .HeadlineLargeTracking, .HeadlineMediumTracking, .HeadlineSmallTracking: return 0.0
            case .LabelLargeTracking, .TitleSmallTracking: return 0.1
            }
        }
    }
}
