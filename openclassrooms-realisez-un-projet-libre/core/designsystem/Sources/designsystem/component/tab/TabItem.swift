//
//  TabItem.swift
//  designsystem
//
//  Created by Damien Gironnet on 05/04/2023.
//

import SwiftUI
import common

///
/// Structure representing Tab row item in application
///
public struct OlaTabRowItem<Content: View>: View {
    
    private let selected: Bool
    internal let onClick: () -> Void
    private let enabled: Bool
    @ViewBuilder private  let content: Content

    public init(selected: Bool = false,
                enabled: Bool = true,
                onClick: @escaping () -> Void,
                @ViewBuilder content: () -> Content) {
        self.selected = selected
        self.enabled = enabled
        self.onClick = onClick
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}
