//
//  CreateOrEditBookmarkGroupView.swift
//  groups
//
//  Created by Damien Gironnet on 18/10/2023.
//

import SwiftUI
import designsystem
import common
import navigation
import model
import ui
import FloatingLabelTextFieldSwiftUI

public struct CreateOrEditBookmarkGroupView: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var viewModel: BookmarksViewModel = BookmarksViewModel.shared
    @ObservedObject private var group: BookmarkGroup
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) internal var colorScheme
    
    private let buttonLabel: String
    private let onCompleted: () -> Void
    
    private let bookmarkTitleTextField: BookmarkTitleTextField = BookmarkTitleTextField()
    
    public init(onCompleted: @escaping () -> Void) {
        group = BookmarkGroup(id: UUID().uuidString, location: .device)
        self.buttonLabel = "create_bookmark_group".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
        self.onCompleted = onCompleted
    }
    
    public init(group: BookmarkGroup, onCompleted: @escaping () -> Void) {
        self.group = group
        self.buttonLabel = "update_bookmark_group".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
        self.onCompleted = onCompleted
        self.bookmarkTitleTextField.title.value = group.directoryName
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            bookmarkTitleTextField.padding(.bottom, isTablet ? 10 : 0)
                .padding(.top, isTablet ? 20 : orientation.isLandscape ? 16 : 0)

            ForEach(BookmarkGroupLocation.allCases, id: \.self) { location in
                BookmarkGroupLocationCheckedBoxButton(
                    label: location.description,
                    isChecked: Binding(
                        get: { group.location == location },
                        set: { _ in }),
                    onClick: { isChecked in
                        if isChecked {
                            group.location = location
                        }
                    })
            }.padding(.bottom, isTablet ? 10 : 0)
            
            OlaTextView(text: $group.shortDescription,
                        placeholder: "description".localizedString(
                            identifier: Locale.current.identifier,
                            bundle: Bundle.designsystem),
                        onTextDidChanged: { })
            .accentColor(localColorScheme.onPrimaryContainer)
            .padding(.bottom,
                (UIScreen.inches > 4.7 ? CGFloat(6.0).adjustHeight() : 6.0 * (UIScreen.main.nativeBounds.height) / 2796))
            .padding(.all, 16)
            .frame(height: UIScreen.main.bounds.height / 3)
            .background(RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .light ? localColorScheme.primaryContainer.opacity(0.35) : localColorScheme.Primary99)
                    .brightness(colorScheme == .light ? 0.0 : -0.03))
            .padding(.top, isTablet ? 0 : 10)
            .padding(.bottom, isTablet ? 30 : 20)
                        
            Button(action: {
                Task {
                    group.directoryName = bookmarkTitleTextField.title.value
                    if group.directoryName.isEmpty {
                        group.directoryName = "undefined".localizedString(identifier: Locale.current.identifier, bundle: Bundle.bookmarks)
                    }
                    try await viewModel.createOrUpdate(group: group)
                    viewModel.updateBookmarkGroups()
                    onCompleted()
                }
            }, label: {
                HStack {
                    Text(buttonLabel)
                        .bold()
                        .foregroundColor(colorScheme == .light ? Color.white : localColorScheme.onPrimaryContainer)
                        .textStyle(isTablet ? TypographyTokens.BodyLarge : TypographyTokens.BodyLarge)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(
                    EdgeInsets(
                        top: CGFloat(0.0).adjustPadding(),
                        leading: CGFloat(16.0).adjustPadding(),
                        bottom: CGFloat(0.0).adjustPadding(),
                        trailing: CGFloat(16.0).adjustPadding()))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            })
            .frame(minWidth: 0, maxWidth: .infinity,
                   minHeight: CGFloat(isTablet ? 45.0 : 45.0).adjustHeight(),
                   maxHeight: CGFloat(isTablet ? 45.0 : 45.0).adjustHeight(),
                   alignment: .center)
            .background(RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .light ? localColorScheme.primary
                          : localColorScheme.Primary90)
                    .shadow(color: colorScheme == .light ? localColorScheme.primary
                            : localColorScheme.primaryContainer,
                            radius: 0.5, x: 0, y: 1))
            .padding(.bottom, isTablet || orientation.isPortrait ? 30 : geometry.safeAreaInsets.bottom)
        }
        .padding(.horizontal, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                 CGFloat(isTablet ? 30.0 : 20.0) : CGFloat(isTablet ? 30.0 : 20.0))
        .padding(.top, orientation == .portrait ? geometry.safeAreaInsets.bottom : CGFloat(10.0).adjustVerticalPadding())
        .padding(.bottom,isTablet || orientation.isPortrait ? 34 : 0)
    }
}
