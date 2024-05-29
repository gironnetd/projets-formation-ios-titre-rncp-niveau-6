//
//  NeumorphismButtonStyle.swift
//  designsystem
//
//  Created by damien on 13/12/2022.
//

import Foundation
import SwiftUI
import model
import common

///
/// Structure to create light button style
///
struct LightButtonStyle: ButtonStyle {

    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(CGFloat(isTablet ? 13.0 : 16.0).adjustPadding())
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(Color.white)
                            .overlay(
                                Circle()
                                    .stroke(localColorScheme.Primary90.opacity(0.9), lineWidth: 4)
                                    .blur(radius: 3)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle()
                                        .fill(LinearGradient(localColorScheme.Primary60, Color.clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 3)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, localColorScheme.Primary30))))
                    } else {
                        Circle()
                            .fill(PaletteTokens.White)
                            .shadow(color: localColorScheme.Primary70.opacity(0.1),
                                    radius: 4, x: 1, y: 2)
                            .shadow(color: PaletteTokens.White.opacity(1.0), radius: 1, x: 0, y: 0)
                    }
                }
            )
    }
}

///
/// Structure to create dark background
///
struct DarkBackground<S: Shape>: View {
    internal var isHighlighted: Bool
    internal var shape: S
    internal var darkBackground: (darkStart: Color, darkEnd: Color)
    
    var body: some View {
        ZStack {
            ZStack {
                if isHighlighted {
                    shape
                        .fill(LinearGradient(darkBackground.darkEnd, darkBackground.darkStart))
                        .overlay(shape.stroke(
                            LinearGradient(darkBackground.darkStart, darkBackground.darkEnd), lineWidth: 4))
                        .shadow(color: PaletteTokens.darkStart.opacity(0.15), radius: 10, x: 5, y: 5)
                        .shadow(color: PaletteTokens.darkEnd.opacity(0.15), radius: 10, x: -5, y: -5)
                } else {
                    shape
                        .fill(LinearGradient(darkBackground.darkStart, darkBackground.darkEnd))
                        .overlay(shape.stroke(darkBackground.darkStart, lineWidth: 4))
                        .shadow(color: PaletteTokens.darkStart.opacity(0.05), radius: 5, x: -5, y: -5)
                        .shadow(color: PaletteTokens.darkEnd.opacity(0.05), radius: 5, x: 5, y: 5)
                }
            }
        }
    }
}

///
/// Structure to create dark button style
///
struct DarkButtonStyle: ButtonStyle {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    private let darkBackground: (darkStart: Color, darkEnd: Color)?
    
    public init(darkBackground: (darkStart: Color, darkEnd: Color)?) {
        self.darkBackground = darkBackground
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        if let darkBackground = darkBackground {
            return configuration.label
                .padding(CGFloat(isTablet ? 13.0 : 16.0).adjustPadding())
                .contentShape(Circle())
                .background(
                    DarkBackground(
                        isHighlighted: configuration.isPressed,
                        shape: Circle(),
                        darkBackground: darkBackground
                    )
                )
        } else {
            return configuration.label
                .padding(CGFloat(16.0).adjustPadding())
                .contentShape(Circle())
                .background(
                    DarkBackground(
                        isHighlighted: configuration.isPressed,
                        shape: Circle(),
                        darkBackground: (localColorScheme.Primary90.opacity(0.5), localColorScheme.Primary99))
                )
        }
    }
}

public extension Button {
    @ViewBuilder
    func neumorphismStyle(for colorScheme: SwiftUI.ColorScheme,
                          darkBackground: (darkStart: Color, darkEnd: Color)? = nil) -> some View {
        switch colorScheme {
        case .light:
            buttonStyle(LightButtonStyle())
        case .dark:
            buttonStyle(DarkButtonStyle(darkBackground: darkBackground))
        @unknown default:
            buttonStyle(LightButtonStyle())
        }
    }
}
