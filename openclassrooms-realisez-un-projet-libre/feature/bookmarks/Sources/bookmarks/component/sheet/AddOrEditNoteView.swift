//
//  AddOrEditNoteView.swift
//  bookmarks
//
//  Created by Damien Gironnet on 19/10/2023.
//

import SwiftUI
import designsystem
import common
import navigation
import model
import FloatingLabelTextFieldSwiftUI

public struct AddOrEditNoteView: View {
    
    @ObservedObject private var viewModel: BookmarksViewModel = BookmarksViewModel.shared
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject public var note: ValueTextField = ValueTextField()
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) internal var colorScheme

    @ObservedObject private var bookmark: Bookmark
    
    private let buttonLabel: String
    private let onCompleted: () -> Void

    public init(bookmark: Bookmark, onCompleted: @escaping () -> Void) {
        self.bookmark = bookmark
        buttonLabel = bookmark.note.isEmpty ? "add_a_note".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) :
        "update_note".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
        self.onCompleted = onCompleted
        self.note.value = bookmark.note
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            OlaTextView(text: $note.value,
                        placeholder: "add_a_brief_description".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem),
                        onTextDidChanged: {  })
            .keyboardType(.emailAddress)
            .accentColor(localColorScheme.onPrimaryContainer)
            .padding(
                .bottom,
                (UIScreen.inches > 4.7 ?
                 CGFloat(6.0).adjustHeight() :
                    6.0 * (UIScreen.main.nativeBounds.height) / 2796))
            .padding(.all, 16)
            .frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 55,
                    idealHeight: 55)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(localColorScheme.primaryContainer.opacity(0.35)))
            .padding(.bottom, isTablet ? 30 : 20)
            .padding(.top, isTablet ? 20 : orientation.isLandscape ? 16 : 0)
            .frame(alignment: .top)
            
            Button(action: { 
                bookmark.note = note.value
                viewModel.update(bookmark: bookmark)
                onCompleted()
            },
                   label: {
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
            .background(RoundedRectangle(cornerRadius: CGFloat(6.0).adjustCornerRadius())
                    .fill(colorScheme == .light ? localColorScheme.primary
                          : (localColorScheme.themeBrand == .primary ? (PaletteTokens.Primary90) : PaletteTokens.Secondary90))
                    .shadow(color: colorScheme == .light ? localColorScheme.primary
                            : localColorScheme.primaryContainer,
                            radius: 0.5, x: 0, y: 1))
            .padding(.bottom, 30)
        }
        .padding(.horizontal, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                 CGFloat(isTablet ? 30.0 : 20.0) : CGFloat(isTablet ? 30.0 : 20.0))
        .padding(.top, orientation == .portrait ? geometry.safeAreaInsets.bottom : CGFloat(10.0).adjustVerticalPadding())
        .padding(.bottom, isTablet ? 44.0 : geometry.safeAreaInsets.bottom)
        .frame(maxHeight: UIScreen.main.bounds.height / 2)
    }
}
