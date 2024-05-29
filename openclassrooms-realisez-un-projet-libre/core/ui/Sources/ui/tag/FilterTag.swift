//
//  FilterTag.swift
//  ui
//
//  Created by Damien Gironnet on 22/08/2023.
//

import SwiftUI
import model
import designsystem

///
/// Structure representing faith filter tag
///
public struct FilterTag: View {
    
    public let text: String
    private let font: UIFont
    public let tag: OlaTopicTag
    private let onClick: () -> Void
    
    public init(text: String,
                enabled: Bool = true,
                font: UIFont,
                onClick: @escaping () -> Void) {
        self.text = text
        self.font = font
        self.onClick = onClick
        self.tag = OlaTopicTag(
            onClick: { onClick() },
            enabled: enabled,
            text: text,
            font: font
        )
    }
    
    public var body: some View {
        tag.padding(.bottom, 4)
    }
}

public class Filter: ObservableObject {
    @Published public var tags: [FilterTag] = []
    
    public init() {}
}
