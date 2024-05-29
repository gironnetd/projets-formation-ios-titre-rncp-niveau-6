//
//  BookmarkLocationCheckedBoxButton.swift
//  ui
//
//  Created by Damien Gironnet on 05/11/2023.
//

import SwiftUI
import model
import designsystem

public struct BookmarkGroupLocationCheckedBoxButton: View {
        
    @Binding var isChecked: Bool
    
    private let label: String
    private let onClick: (Bool) -> Void
    
    public init(label: String,
                isChecked: Binding<Bool>,
                onClick: @escaping (Bool) -> Void) {
        self.label = label
        self._isChecked = isChecked
        self.onClick = onClick
    }
    
    public var body: some View {
        CheckBoxButton(
            label: label,
            isChecked: $isChecked,
            onClick: { isChecked in onClick(isChecked) })
    }
}
