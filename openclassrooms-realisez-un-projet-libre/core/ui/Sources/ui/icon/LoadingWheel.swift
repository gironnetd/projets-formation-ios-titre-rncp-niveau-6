//
//  WheelLoading.swift
//  ui
//
//  Created by Damien Gironnet on 18/05/2023.
//

import SwiftUI
import designsystem
import common

public class LoadingWheel: ObservableObject {
    @Published public var isShowing: Bool
    
    public init() {
        isShowing = LoadingWheel.shared.isShowing
    }
    
    public init(isShowing: Bool) {
        self.isShowing = isShowing
    }
    
    public static let shared = LoadingWheel(isShowing: false)
    
    public static func isShowing(_ isShowing: Bool) {
        withAnimation {
            LoadingWheel.shared.isShowing = isShowing
        }
    }
}

///
/// Variable representing WheelLoading for application
///
public struct OlaLoadingWheel: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var loadingWheel: LoadingWheel = LoadingWheel.shared

    @State private var isRotating = 0.0
    
    public init() {}
    
    public var body: some View {
        if isTablet {
            OlaIcons.WheelLoading
                .resizable()
                .renderingMode(.template)
                .foregroundColor(colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary20)
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat(52).adjustVerticalPadding())
                .rotationEffect(.degrees(isRotating))
                .onAppear {
                    withAnimation(.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)) {
                            isRotating = 360.0
                        }
                }
                .onDisappear { isRotating = 0.0 }
                .opacity(loadingWheel.isShowing ? 1 : 0)
        } else {
            OlaIcons.WheelLoading.renderingMode(.template)
                .foregroundColor(colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary20)
                .rotationEffect(.degrees(isRotating))
                .onAppear {
                    withAnimation(.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)) {
                            isRotating = 360.0
                        }
                }
                .onDisappear { isRotating = 0.0 }
                .opacity(loadingWheel.isShowing ? 1 : 0)
        }
    }
}

internal struct OlaLoadingWheel_Previews: PreviewProvider {
    static var previews: some View {
        OlaLoadingWheel().environmentObject(OlaColorScheme(themeBrand: .primary))
    }
}
