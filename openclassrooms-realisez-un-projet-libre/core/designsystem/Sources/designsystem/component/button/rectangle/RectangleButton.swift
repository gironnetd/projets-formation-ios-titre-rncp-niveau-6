//
//  RectangleButton.swift
//  designsystem
//
//  Created by Damien Gironnet on 10/03/2023.
//

import Foundation
import SwiftUI
import common

///
/// Enum representing action on button
///
public enum ButtonAction: String {
    case create = "create_an_account"
    case signin = "sign_in"
}

///
/// Protocol for all rectangle button
///
protocol RectangleButton: GenericButton {
    var colorScheme: ColorScheme { get }
    var localColorScheme: OlaColorScheme { get }
    var action: ButtonAction { get set }
    var signIn: () async throws -> Void { get set }
}

extension RectangleButton {
    
//    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    public var body: some View {
        Button(
            action: { Task { try await signIn() } },
            label: {
                HStack {
                    Text(action.rawValue.localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem))
                        .bold()
                        .foregroundColor(colorScheme == .light ? Color.white : localColorScheme.onPrimaryContainer)
                        .textStyle(isTablet ? TypographyTokens.BodyLarge : TypographyTokens.BodyLarge)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(
                    EdgeInsets(
                        top: CGFloat(0.0).adjustPadding(),
                        leading: CGFloat(16.0).adjustPadding(),
                        bottom: CGFloat(0.0).adjustPadding(),
                        trailing: CGFloat(16.0).adjustPadding()))
            })
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: CGFloat(isTablet ? 45.0 : 45.0).adjustHeight(),
               maxHeight: CGFloat(isTablet ? 45.0 : 45.0).adjustHeight(),
               alignment: .center
        )
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .light ? localColorScheme.primary
                      : localColorScheme.Primary90)
                .shadow(color: colorScheme == .light ? localColorScheme.primary
                        : localColorScheme.primaryContainer,
                        radius: 0.5, x: 0, y: 1))
    }
}
