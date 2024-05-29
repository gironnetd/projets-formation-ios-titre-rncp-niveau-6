//
//  ColorScheme.swift
//  designsystem
//
//  Created by damien on 20/12/2022.
//

import Foundation
import SwiftUI
import model

///
/// Class for ColorScheme in application
///
public class OlaColorScheme: ObservableObject {
    @Published public var colorScheme: ColorScheme = .light
    @Published public var primary: Color = Color.clear
    @Published public var onPrimary: Color = Color.clear
    @Published public var primaryContainer: Color = Color.clear
    @Published public var onPrimaryContainer: Color = Color.clear
    @Published public var inversePrimary: Color = Color.clear
    @Published public var background: Color = Color.clear
    @Published public var onBackground: Color = Color.clear
    @Published public var surface: Color = Color.clear
    @Published public var onSurface: Color = Color.clear
    @Published public var surfaceVariant: Color = Color.clear
    @Published public var onSurfaceVariant: Color = Color.clear
    @Published public var surfaceTint: Color = Color.clear
    @Published public var inverseSurface: Color = Color.clear
    @Published public var inverseOnSurface: Color = Color.clear
    @Published public var error: Color = Color.clear
    @Published public var onError: Color = Color.clear
    @Published public var errorContainer: Color = Color.clear
    @Published public var onErrorContainer: Color = Color.clear
    @Published public var outline: Color = Color.clear
    @Published public var outlineVariant: Color = Color.clear
    @Published public var scrim: Color = Color.clear
    
    @Published public var Primary0 = Color.clear
    @Published public var Primary10 = Color.clear
    @Published public var Primary20 = Color.clear
    @Published public var Primary30 = Color.clear
    @Published public var Primary40 = Color.clear
    @Published public var Primary5 = Color.clear
    @Published public var Primary50 = Color.clear
    @Published public var Primary60 = Color.clear
    @Published public var Primary70 = Color.clear
    @Published public var Primary80 = Color.clear
    @Published public var Primary90 = Color.clear
    @Published public var Primary95 = Color.clear
    @Published public var Primary99 = Color.clear
    @Published public var Primary100 = Color.clear
    
    public static var shared = OlaColorScheme()
    
    public var themeBrand: ThemeBrand = .primary {
        willSet {
            switch newValue {
            case .primary:
                self.Primary0 = PaletteTokens.Primary0
                self.Primary5 = PaletteTokens.Primary5
                self.Primary10 = PaletteTokens.Primary10
                self.Primary20 = PaletteTokens.Primary20
                self.Primary30 = PaletteTokens.Primary30
                self.Primary40 = PaletteTokens.Primary40
                self.Primary50 = PaletteTokens.Primary50
                self.Primary60 = PaletteTokens.Primary60
                self.Primary70 = PaletteTokens.Primary70
                self.Primary80 = PaletteTokens.Primary80
                self.Primary90 = PaletteTokens.Primary90
                self.Primary95 = PaletteTokens.Primary95
                self.Primary99 = PaletteTokens.Primary99
                self.Primary100 = PaletteTokens.Primary100
                self.primary = PaletteTokens.Primary
                self.onPrimary = PaletteTokens.OnPrimary
                self.primaryContainer = PaletteTokens.PrimaryContainer
                self.onPrimaryContainer = PaletteTokens.OnPrimaryContainer
                self.inversePrimary = PaletteTokens.InversePrimary
            case .secondary:
                self.Primary0 = PaletteTokens.Secondary0
                self.Primary5 = PaletteTokens.Secondary5
                self.Primary10 = PaletteTokens.Secondary10
                self.Primary20 = PaletteTokens.Secondary20
                self.Primary30 = PaletteTokens.Secondary30
                self.Primary40 = PaletteTokens.Secondary40
                self.Primary50 = PaletteTokens.Secondary50
                self.Primary60 = PaletteTokens.Secondary60
                self.Primary70 = PaletteTokens.Secondary70
                self.Primary80 = PaletteTokens.Secondary80
                self.Primary90 = PaletteTokens.Secondary90
                self.Primary95 = PaletteTokens.Secondary95
                self.Primary99 = PaletteTokens.Secondary99
                self.Primary100 = PaletteTokens.Secondary100
                self.primary = PaletteTokens.Secondary
                self.onPrimary = PaletteTokens.OnSecondary
                self.primaryContainer = PaletteTokens.SecondaryContainer
                self.onPrimaryContainer = PaletteTokens.OnSecondaryContainer
                self.inversePrimary = PaletteTokens.InversePrimary
            case .tertiary:
                self.Primary0 = PaletteTokens.Tertiary0
                self.Primary5 = PaletteTokens.Tertiary5
                self.Primary10 = PaletteTokens.Tertiary10
                self.Primary20 = PaletteTokens.Tertiary20
                self.Primary30 = PaletteTokens.Tertiary30
                self.Primary40 = PaletteTokens.Tertiary40
                self.Primary50 = PaletteTokens.Tertiary50
                self.Primary60 = PaletteTokens.Tertiary60
                self.Primary70 = PaletteTokens.Tertiary70
                self.Primary80 = PaletteTokens.Tertiary80
                self.Primary90 = PaletteTokens.Tertiary90
                self.Primary95 = PaletteTokens.Tertiary95
                self.Primary99 = PaletteTokens.Tertiary99
                self.Primary100 = PaletteTokens.Tertiary100
                self.primary = PaletteTokens.Tertiary
                self.onPrimary = PaletteTokens.OnTertiary
                self.primaryContainer = PaletteTokens.TertiaryContainer
                self.onPrimaryContainer = PaletteTokens.OnTertiaryContainer
                self.inversePrimary = PaletteTokens.InversePrimary
            case .quaternary:
                self.Primary0 = PaletteTokens.Quaternary0
                self.Primary5 = PaletteTokens.Quaternary5
                self.Primary10 = PaletteTokens.Quaternary10
                self.Primary20 = PaletteTokens.Quaternary20
                self.Primary30 = PaletteTokens.Quaternary30
                self.Primary40 = PaletteTokens.Quaternary40
                self.Primary50 = PaletteTokens.Quaternary50
                self.Primary60 = PaletteTokens.Quaternary60
                self.Primary70 = PaletteTokens.Quaternary70
                self.Primary80 = PaletteTokens.Quaternary80
                self.Primary90 = PaletteTokens.Quaternary90
                self.Primary95 = PaletteTokens.Quaternary95
                self.Primary99 = PaletteTokens.Quaternary99
                self.Primary100 = PaletteTokens.Quaternary100
                self.primary = PaletteTokens.Quaternary
                self.onPrimary = PaletteTokens.OnQuaternary
                self.primaryContainer = PaletteTokens.QuaternaryContainer
                self.onPrimaryContainer = PaletteTokens.OnQuaternaryContainer
                self.inversePrimary = PaletteTokens.InversePrimary
            }
            objectWillChange.send()
        }
    }
    
    public init() { }
    
    public init(themeBrand: ThemeBrand) {
        self.themeBrand = themeBrand
    }
    
    public init(themeBrand: ThemeBrand,
                colorScheme: ColorScheme,
                primary: Color,
                onPrimary: Color,
                primaryContainer: Color,
                onPrimaryContainer: Color,
                inversePrimary: Color,
                secondary: Color,
                onSecondary: Color,
                secondaryContainer: Color,
                onSecondaryContainer: Color,
                tertiary: Color,
                onTertiary: Color,
                tertiaryContainer: Color,
                onTertiaryContainer: Color,
                background: Color,
                onBackground: Color,
                surface: Color,
                onSurface: Color,
                surfaceVariant: Color,
                onSurfaceVariant: Color,
                surfaceTint: Color,
                inverseSurface: Color,
                inverseOnSurface: Color,
                error: Color,
                onError: Color,
                errorContainer: Color,
                onErrorContainer: Color,
                outline: Color,
                outlineVariant: Color,
                scrim: Color) {
        self.themeBrand = themeBrand
        self.colorScheme = colorScheme
        self.primary = primary
        self.onPrimary = onPrimary
        self.primaryContainer = primaryContainer
        self.onPrimaryContainer = onPrimaryContainer
        self.inversePrimary = inversePrimary
        self.background = background
        self.onBackground = onBackground
        self.surface = surface
        self.onSurface = onSurface
        self.surfaceVariant = surfaceVariant
        self.onSurfaceVariant = onSurfaceVariant
        self.surfaceTint = surfaceTint
        self.inverseSurface = inverseSurface
        self.inverseOnSurface = inverseOnSurface
        self.error = error
        self.onError = onError
        self.errorContainer = errorContainer
        self.onErrorContainer = onErrorContainer
        self.outline = outline
        self.outlineVariant = outlineVariant
        self.scrim = scrim
        
        switch themeBrand {
        case .primary :
            self.Primary0 = PaletteTokens.Primary0
            self.Primary5 = PaletteTokens.Primary5
            self.Primary10 = PaletteTokens.Primary10
            self.Primary20 = PaletteTokens.Primary20
            self.Primary30 = PaletteTokens.Primary30
            self.Primary40 = PaletteTokens.Primary40
            self.Primary50 = PaletteTokens.Primary50
            self.Primary60 = PaletteTokens.Primary60
            self.Primary70 = PaletteTokens.Primary70
            self.Primary80 = PaletteTokens.Primary80
            self.Primary90 = PaletteTokens.Primary90
            self.Primary95 = PaletteTokens.Primary95
            self.Primary99 = PaletteTokens.Primary99
            self.Primary100 = PaletteTokens.Primary100
        case .secondary :
            self.Primary0 = PaletteTokens.Secondary0
            self.Primary5 = PaletteTokens.Secondary5
            self.Primary10 = PaletteTokens.Secondary10
            self.Primary20 = PaletteTokens.Secondary20
            self.Primary30 = PaletteTokens.Secondary30
            self.Primary40 = PaletteTokens.Secondary40
            self.Primary50 = PaletteTokens.Secondary50
            self.Primary60 = PaletteTokens.Secondary60
            self.Primary70 = PaletteTokens.Secondary70
            self.Primary80 = PaletteTokens.Secondary80
            self.Primary90 = PaletteTokens.Secondary90
            self.Primary95 = PaletteTokens.Secondary95
            self.Primary99 = PaletteTokens.Secondary99
            self.Primary100 = PaletteTokens.Secondary100
        case .tertiary:
            self.Primary0 = PaletteTokens.Tertiary0
            self.Primary5 = PaletteTokens.Tertiary5
            self.Primary10 = PaletteTokens.Tertiary10
            self.Primary20 = PaletteTokens.Tertiary20
            self.Primary30 = PaletteTokens.Tertiary30
            self.Primary40 = PaletteTokens.Tertiary40
            self.Primary50 = PaletteTokens.Tertiary50
            self.Primary60 = PaletteTokens.Tertiary60
            self.Primary70 = PaletteTokens.Tertiary70
            self.Primary80 = PaletteTokens.Tertiary80
            self.Primary90 = PaletteTokens.Tertiary90
            self.Primary95 = PaletteTokens.Tertiary95
            self.Primary99 = PaletteTokens.Tertiary99
            self.Primary100 = PaletteTokens.Tertiary100
        case .quaternary:
            self.Primary0 = PaletteTokens.Quaternary0
            self.Primary5 = PaletteTokens.Quaternary5
            self.Primary10 = PaletteTokens.Quaternary10
            self.Primary20 = PaletteTokens.Quaternary20
            self.Primary30 = PaletteTokens.Quaternary30
            self.Primary40 = PaletteTokens.Quaternary40
            self.Primary50 = PaletteTokens.Quaternary50
            self.Primary60 = PaletteTokens.Quaternary60
            self.Primary70 = PaletteTokens.Quaternary70
            self.Primary80 = PaletteTokens.Quaternary80
            self.Primary90 = PaletteTokens.Quaternary90
            self.Primary95 = PaletteTokens.Quaternary95
            self.Primary99 = PaletteTokens.Quaternary99
            self.Primary100 = PaletteTokens.Quaternary100
        }
    }
}
