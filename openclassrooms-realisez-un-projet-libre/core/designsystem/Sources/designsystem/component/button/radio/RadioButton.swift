//
//  RadioButton.swift
//  designsystem
//
//  Created by Damien Gironnet on 09/10/2023.
//

import SwiftUI

public struct RadioButton: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var selectedRadioButton: String
    private let label: String
    private let onClick: (String) -> Void
    
    public init(label:String,
                selectedRadioButton: Binding<String>,
                onClick: @escaping (String) -> Void) {
        self._selectedRadioButton = selectedRadioButton
        self.label = label
        self.onClick = onClick
    }
    
    public var body: some View {
        if selectedRadioButton == label {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(selectedRadioButton == label ? (colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer) : (localColorScheme.Primary20), lineWidth: 2.2)
                        .frame(width: 20, height: 20)
                    
                        Circle()
                            .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer)
                            .frame(width: 10, height: 10)
                    
                }
                
                Text(label)
                    .foregroundColor(localColorScheme.Primary20)
                    .textStyle(TypographyTokens.BodyLarge)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                onClick(label)
            }
        } else {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(selectedRadioButton == label ? (colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer) : (localColorScheme.Primary20), lineWidth: 2.2)
                        .frame(width: 20, height: 20)
                }
                
                Text(label)
                    .foregroundColor(localColorScheme.Primary20)
                    .textStyle(TypographyTokens.BodyLarge)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                onClick(label)
            }
        }
    }
}
