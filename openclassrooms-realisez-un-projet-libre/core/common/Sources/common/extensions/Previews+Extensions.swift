//
//  Previews+Extensions.swift
//  common
//
//  Created by damien on 06/12/2022.
//

import Foundation
import SwiftUI

struct LandscapeModifier: ViewModifier {
    private let height = UIScreen.main.bounds.width
    private let width = UIScreen.main.bounds.height

    func body(content: Content) -> some View {
        content
            .previewLayout(.fixed(width: width, height: height))
            .environment(\.horizontalSizeClass, .regular)
            .environment(\.verticalSizeClass, .compact)
    }
}

extension View {
    public func landscape() -> some View {
        self.modifier(LandscapeModifier())
    }
}

public enum DarkMode {
    case only, both, none
}

///
/// Variable allowing to know if the context is in Preview mode or not
///
public var isPreview: Bool {
    #if DEBUG
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    #else
    return false
    #endif
}

public struct UIElementPreview<Value: View>: View {

    private let dynamicTypeSizes: [ContentSizeCategory] = [.small, .medium, .large, .extraLarge]

    /// Filter out "base" to prevent a duplicate preview.
    private let localizations: [Locale]
    private let viewToPreview: Value
    private let previewLayout: PreviewLayout
    private let darkMode: DarkMode
    private let multiLanguage: Bool
    private let landscapeMode: Bool

    public init(_ viewToPreview: Value,
                darkMode: DarkMode,
                multiLanguage: Bool,
                landscapeMode: Bool,
                previewLayout: PreviewLayout = PreviewLayout.sizeThatFits,
                bundle: Bundle) {
        localizations = bundle.localizations.map(Locale.init)
            .filter { $0.identifier != "base" }
        self.viewToPreview = viewToPreview
        self.darkMode = darkMode
        self.multiLanguage = multiLanguage
        self.landscapeMode = landscapeMode
        self.previewLayout = previewLayout
    }

    public var body: some View {
            switch darkMode {

            case .none:
                self.viewToPreview
                    .previewLayout(previewLayout)
                    .previewDisplayName("Default Preview Portrait")

                if landscapeMode {
                    self.viewToPreview
                        .landscape()
                        .previewDisplayName("Default Preview Landscape")
                }
            case .only:
                self.viewToPreview
                    .previewLayout(previewLayout)
                    .background(Color(.systemBackground))
                    .preferredColorScheme(ColorScheme.dark)
                    .previewDisplayName("Dark Mode Portrait")

                if landscapeMode {
                    self.viewToPreview
                        .landscape()
                        .background(Color(.systemBackground))
                        .environment(\.colorScheme, .dark)
                        .previewDisplayName("Dark Mode Landscape")
                }
            case .both:
                self.viewToPreview
                    .previewLayout(previewLayout)
                    .previewDisplayName("Default Preview Portrait")

                if landscapeMode {
                    self.viewToPreview
                        .landscape()
                        .previewDisplayName("Default Preview Landscape")
                }

                self.viewToPreview
                    .previewLayout(previewLayout)
                    .background(Color(.systemBackground))
                    .preferredColorScheme(ColorScheme.dark)
                    .previewDisplayName("Dark Mode Portrait")

                if landscapeMode {
                    self.viewToPreview
                        .landscape()
                        .background(Color(.systemBackground))
                        .environment(\.colorScheme, .dark)
                        .previewDisplayName("Dark Mode Landscape")
                }
            }

            if multiLanguage {
                ForEach(localizations, id: \.identifier) { locale in
                    self.viewToPreview
                        .previewLayout(previewLayout)
                        .environment(\.locale, .init(identifier: locale.identifier))
                        .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
                }
            }
    }
}
