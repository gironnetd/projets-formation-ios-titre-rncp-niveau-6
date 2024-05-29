//
//  Gradient.swift
//  designsystem
//
//  Created by damien on 14/12/2022.
//

import Foundation
import SwiftUI

public extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

public class GradientColors: ObservableObject {
    
    @Published public var top: Color = Color.clear
    @Published public var bottom: Color = Color.clear
    @Published public var container: Color = Color.clear
    
    init() {}
    
    init(top: Color, bottom: Color, container: Color) {
        self.top = top
        self.bottom = bottom
        self.container = container
    }
}
