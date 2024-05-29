//
//  CheckBoxButton.swift
//  designsystem
//
//  Created by Damien Gironnet on 16/10/2023.
//

import SwiftUI
import common

public struct CheckBoxButton: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var isChecked: Bool
    private let label: String
    private let onClick: (Bool) -> Void
    
    public init(label:String,
                isChecked: Binding<Bool>,
                onClick: @escaping (Bool) -> Void) {
        self._isChecked = isChecked
        self.label = label
        self.onClick = onClick
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if isChecked {
                OlaIcons.CheckBoxChecked
                    .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30)
            } else {
                OlaIcons.CheckBox.foregroundColor(colorScheme == .light ? Color.black : Color.white)
            }
            
            Text(label).textStyle(TypographyTokens.BodyLarge).foregroundColor(colorScheme == .light ? Color.black : Color.white)
                .padding(.top, isTablet ? 0 : 6.0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            onClick(!isChecked)
            isChecked.toggle()
        }
    }
}

