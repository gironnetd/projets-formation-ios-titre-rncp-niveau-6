//
//  IconButton.swift
//  designsystem
//
//  Created by Damien Gironnet on 25/04/2023.
//

import SwiftUI

///
/// Structure representing icon toggle button
///
public struct OlaIconToggleButton<Content: View>: View {
    
    @Binding private var checked: Bool
    private let onCheckedChange: (Bool) -> Void
    private var enabled: Bool
    private let icon: Content
    private let checkedIcon: Content
    
    public init(checked: Binding<Bool>,
                onCheckedChange: @escaping (Bool) -> Void,
                enabled: Bool/*Binding<Bool>*/,
                @ViewBuilder icon: @escaping () -> Content,
                @ViewBuilder checkedIcon: @escaping () -> Content) {
        self._checked = checked
        self.onCheckedChange = onCheckedChange
        self.enabled = enabled
        self.icon = icon()
        self.checkedIcon = checkedIcon()
    }
    
    public var body: some View {
        (checked ? checkedIcon : icon)
            .onTapGesture {
                if enabled {
                    onCheckedChange(!checked)
                    checked.toggle()
                } else {
                    onCheckedChange(!checked)
                }
            }
    }
}

internal struct OlaIconToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        OlaIconToggleButton(
            checked: .constant(true),
            onCheckedChange: { checkedChange in
                print("Is Checked: \(checkedChange)")
            },
            enabled: true/*.constant(true)*/,
            icon: { OlaIcons.BookmarkBorder },
            checkedIcon: { OlaIcons.Bookmark })
    }
}
