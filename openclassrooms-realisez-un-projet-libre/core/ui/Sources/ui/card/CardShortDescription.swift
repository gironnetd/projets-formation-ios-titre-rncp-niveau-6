//
//  CardShortDescription.swift
//  ui
//
//  Created by Damien Gironnet on 25/04/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

///
/// Structure representing card short description
///
public struct CardShortDescription: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
    
    private let shortDescription: String
    
    public init(shortDescription: String) {
        self.shortDescription = shortDescription
    }
    
    public var body: some View {
        Text(shortDescription.trimmingCharacters(in: .whitespacesAndNewlines))
            .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.primary)
            .textStyle(TypographyTokens.HeadlineSmall)
            .lineLimit(4)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }
}
