//
//  MainBottomTab.swift
//  main
//
//  Created by Damien Gironnet on 06/04/2023.
//

import SwiftUI
import Foundation
import common
import designsystem

///
/// Bottom Tab for main screen
///
public struct MainBottomTab: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.orientation) private var orientation
    
    @Binding var selectedTabIndex: Int

    @Environment(\.colorScheme) private var colorScheme
    
    private let index: Int
    private let selectedIcon: Image
    private let icon: Image
    
    public init(index: Int,
                selectedTabIndex: Binding<Int>,
                selectedIcon: Image,
                icon: Image) {
        self.index = index
        self._selectedTabIndex = selectedTabIndex
        self.selectedIcon = selectedIcon
        self.icon = icon
    }
    
    public var body: some View {
        if selectedTabIndex == index {
            if isTablet {
                selectedIcon.resizable()
                    .renderingMode(.template)
                    .foregroundColor(
                        colorScheme == .light ? localColorScheme.Primary40 : localColorScheme.Primary5)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: CGFloat(38).adjustVerticalPadding())
                    .padding(.vertical, 20)
            } else {
                if UIScreen.inches > 4.7 {
                    selectedIcon
                        .renderingMode(.template)
                        .foregroundColor(
                            colorScheme == .light ? localColorScheme.Primary40 : localColorScheme.Primary5)
                        .padding(.vertical, orientation.isLandscape ? (UIScreen.main.scale == 3 ? 16 : 20) : 0)
                } else {
                    selectedIcon.resizable()
                        .renderingMode(.template)
                        .foregroundColor(
                            colorScheme == .light ? localColorScheme.Primary40 : localColorScheme.Primary5)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: CGFloat(40).adjustVerticalPadding())
                        .padding(.vertical, orientation.isLandscape ? 10 : 0)
                }
            }
        } else {
            if isTablet {
                icon.resizable()
                    .renderingMode(.template)
                    .foregroundColor(
                        colorScheme == .light ? localColorScheme.Primary80 : localColorScheme.Primary20)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: CGFloat(38).adjustVerticalPadding())
                    .padding(.vertical, 20)
            } else {
                if UIScreen.inches > 4.7 {
                    icon.renderingMode(.template)
                        .foregroundColor(
                            colorScheme == .light ? localColorScheme.Primary80 : localColorScheme.Primary20)
                        .padding(.vertical, orientation.isLandscape ? (UIScreen.main.scale == 3 ? 16 : 20) : 0)
                } else {
                    icon.resizable()
                        .renderingMode(.template)
                        .foregroundColor(
                            colorScheme == .light ? localColorScheme.Primary80 : localColorScheme.Primary20)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: CGFloat(40).adjustVerticalPadding())
                        .padding(.vertical, orientation.isLandscape ? 10 : 0)
                }
            }
        }
    }
}
