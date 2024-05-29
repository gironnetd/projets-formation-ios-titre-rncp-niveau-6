//
//  OlaIcons.swift
//  designsystem
//
//  Created by damien on 07/12/2022.
//

import Foundation
import SwiftUI

///
/// final class for all icons in application
///
public final class OlaIcons {
    public static let DoveIcon = Image("dove", bundle: Bundle.designsystem)
    public static let Google = Image("google", bundle: .designsystem)
    public static let Apple = Image("apple", bundle: .designsystem)
    public static let Twitter = Image("twitter", bundle: .designsystem)
    public static let Facebook = Image("facebook", bundle: .designsystem)
    public static let PrimaryFlowersLeft = Image("primary_flowers_left", bundle: Bundle.designsystem)
    public static let PrimaryFlowersRight = Image("primary_flowers_right", bundle: Bundle.designsystem)
    public static let SecondaryFlowersLeft = Image("complementary_secondary_flowers_left", bundle: Bundle.designsystem)
    public static let SecondaryFlowersRight = Image("complementary_secondary_flowers_right", bundle: Bundle.designsystem)
    public static let TertiaryFlowersLeft = Image("tertiary_flowers_left", bundle: Bundle.designsystem)
    public static let TertiaryFlowersRight = Image("tertiary_flowers_right", bundle: Bundle.designsystem)
    public static let QuaternaryFlowersLeft = Image("quaternary_flowers_left", bundle: Bundle.designsystem)
    public static let QuaternaryFlowersRight = Image("quaternary_flowers_right", bundle: Bundle.designsystem)
    public static let PrimaryEmail = Image("primary_email", bundle: .designsystem)
    public static let PrimaryUsername = Image("primary_username", bundle: .designsystem)
    public static let PrimaryPassword = Image("primary_password", bundle: .designsystem)
    public static let ComplementaryEmail = Image("complementary_secondary_email", bundle: .designsystem)
    public static let ComplementaryUsername = Image("complementary_secondary_username", bundle: .designsystem)
    public static let ComplementaryPassword = Image("complementary_secondary_password", bundle: .designsystem)
    public static let BookmarksBorder = Image("bookmarks_border", bundle: .designsystem)
    public static let BookmarkBorder = Image("bookmark_border", bundle: .designsystem)
    public static let Bookmark = Image("bookmark", bundle: .designsystem)
    public static let HomeBorder = Image("home_border", bundle: .designsystem)
    public static let Search = Image("search", bundle: .designsystem)
    public static let Settings = Image("more_vertical_icon", bundle: .designsystem)
    public static let Backward = Image("back_icon", bundle: .designsystem)
    public static let Forward = Image("forward_icon", bundle: .designsystem)
    public static let ArrowRight = Image("arrow_right", bundle: .designsystem)
    public static let ArrowLeft = Image("arrow_left_icon", bundle: .designsystem)
    public static let ArrowBottom = Image("arrow_bottom", bundle: .designsystem)
    public static let WheelLoading = Image("wheel", bundle: .designsystem)
    public static let Quotes = Image("quotes", bundle: .designsystem)
    public static let Biography = Image("biography", bundle: .designsystem)
    public static let Pictures = Image("pictures", bundle: .designsystem)
    public static let User = Image("user", bundle: .designsystem)
    public static let Padlock = Image("padlock_icon_1", bundle: .designsystem)
    public static let CheckBox = Image("checkbox_icon", bundle: .designsystem)
    public static let CheckBoxChecked = Image("checkbox_checked_icon", bundle: .designsystem)
    public static let Menu = Image("menu_icon_1", bundle: .designsystem)
}

public enum AspectRatio {
    
    case Apple, Facebook
    
    public var value: CGSize {
        switch self {
        case .Apple:
            return CGSize(width: 76, height: 96)
        case .Facebook:
            return CGSize(width: 51, height: 96)
        }
    }
}
