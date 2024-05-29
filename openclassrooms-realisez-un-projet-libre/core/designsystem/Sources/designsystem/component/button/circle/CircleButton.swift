//
//  CircleButton.swift
//  designsystem
//
//  Created by Damien Gironnet on 08/03/2023.
//

import Foundation
import SwiftUI

///
/// Protocol for all circle button
///
protocol CircleButton: GenericButton {
    var provider: Provider { get set }
    var colorScheme: ColorScheme { get }
    var localColorScheme: OlaColorScheme { get }
    var height: CGFloat { get set }
    var width: CGFloat { get set }
    var signIn: () async throws -> Void { get set }
}

extension CircleButton {
    public var body: some View {
        Button(
            action: { Task { try await signIn() } },
            label: {
                Group {
                    Image(provider.rawValue, bundle: .designsystem)
                        .resizable()
                        .frame(width: width, height: height, alignment: .center)
                }
                .frame(width: height, height: height, alignment: .center)
            }).neumorphismStyle(for: colorScheme)
    }
}
