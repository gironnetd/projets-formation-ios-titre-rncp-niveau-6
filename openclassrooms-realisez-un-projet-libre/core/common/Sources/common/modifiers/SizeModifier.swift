//
//  SizeModifier.swift
//  common
//
//  Created by Damien Gironnet on 11/03/2023.
//

import Foundation
import SwiftUI

///
/// Structure for the SizePreference PreferenceKey
///
public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

///
/// Structure for the SizeModifier ViewModifier
///
public struct SizeModifier: ViewModifier {
    
    public init() {}
    
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }

    public func body(content: Content) -> some View {
        content.overlay(sizeView)
    }
}
