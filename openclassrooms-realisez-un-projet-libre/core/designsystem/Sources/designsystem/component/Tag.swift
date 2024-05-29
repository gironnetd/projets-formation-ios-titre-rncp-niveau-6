//
//  Tag.swift
//  designsystem
//
//  Created by Damien Gironnet on 24/04/2023.
//

import SwiftUI
import common

public struct OlaTopicTagStyle: ViewModifier {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @ObservedObject public var followed: Followed
    
    @Environment(\.colorScheme) private var colorScheme
    
    public class Followed: ObservableObject {
        @Published public var value: Bool
        
        init(followed: Bool) {
            self.value = followed
        }
    }
    
    private let onClick: () -> Void
    private let enabled: Bool
    
    public init(followed: Bool = false,
                onClick: @escaping () -> Void,
                enabled: Bool = true) {
        self.followed = Followed(followed: followed)
        self.onClick = onClick
        self.enabled = enabled
    }
    
    public func body(content: Content) -> some View {
        Button(
            action: {
                if enabled {
                    followed.value.toggle()
                }
                onClick()
            }, label: {
                content
                    .foregroundColor(
                        followed.value ?
                        (colorScheme == .light ? localColorScheme.onPrimary : localColorScheme.onPrimaryContainer) :
                            (colorScheme == .light ? (localColorScheme.primary) : localColorScheme.onPrimaryContainer))
            })
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .circular)
                .foregroundColor(
                    followed.value ?
                    (colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30) :
                        (colorScheme == .light ? localColorScheme.primaryContainer.opacity(0.4)
                         : localColorScheme.Primary60.opacity(0.50))))
    }
}

public extension View {
    func FollowableTopicTag(followed: Bool, onClick: @escaping () -> Void, enabled: Bool) -> some View {
        modifier(OlaTopicTagStyle(followed: followed, onClick: onClick, enabled: enabled))
    }
}

///
/// Structure for topic tag in application
///
public struct OlaTopicTag: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject public var followed: Followed
    
    @Environment(\.colorScheme) private var colorScheme
    
    public class Followed: ObservableObject {
        @Published public var value: Bool
        
        init(followed: Bool) {
            self.value = followed
        }
    }
    
    private let onClick: () -> Void
    private let enabled: Bool
    private let text: String
    private let font: UIFont
    
    public init(followed: Bool = false,
                onClick: @escaping () -> Void,
                enabled: Bool = true,
                text: String,
                font: UIFont) {
        self.followed = Followed(followed: followed)
        self.onClick = onClick
        self.enabled = enabled
        self.text = text
        self.font = font
    }
    
    public var body: some View {
        Button(
            action: {
                if enabled {
                    followed.value.toggle()
                }
                onClick()
            }, label: {
                Text(text)
                    .font(Font(font))
                    .foregroundColor(
                        followed.value ?
                        (colorScheme == .light ? localColorScheme.onPrimary : localColorScheme.onPrimaryContainer) :
                            (colorScheme == .light ? (localColorScheme.primary) : localColorScheme.onPrimaryContainer))
                    .padding(.horizontal, 6)
            }).disabled(!enabled)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .circular)
                .foregroundColor(
                    followed.value ?
                    (colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30) :
                        (colorScheme == .light ? localColorScheme.primaryContainer.opacity(0.4)
                         : localColorScheme.Primary60.opacity(0.50)))
        )
    }
}

internal struct OlaTopicTag_Previews: PreviewProvider {
    public static var previews: some View {
        GeometryReader { geometry in
            OlaTheme(darkTheme: .systemDefault) {
                OlaTopicTag(followed: true,
                            onClick: { print("On Click ") },
                            enabled: true,
                            text: "Hello, World!!!".uppercased(),
                            font: TypographyTokens.BodyLarge.customFont.uiFont
                )
                .OlaBackground()
                .padding(.top, geometry.safeAreaInsets.top)
            }
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "fr"))
            .ignoresSafeArea()
        }
    }
}
