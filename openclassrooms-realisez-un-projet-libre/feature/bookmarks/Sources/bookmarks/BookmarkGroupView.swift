//
//  BookmarkGroupView.swift
//  bookmarks
//
//  Created by Damien Gironnet on 22/10/2023.
//

import Foundation
import SwiftUI
import common
import designsystem
import ui
import model
import navigation

public struct BookmarkGroupView: View {

    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject var viewModel: BookmarksViewModel
    @ObservedObject private var frame: Frame
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.geometry) private var geometry
    @Environment(\.orientation) private var orientation
    
    @State private var tmpSize: CGSize = .zero
    
    private let onBookmarkClick: (BookmarkGroup) -> Void
    
    public init(frame: Frame, onBookmarkClick: @escaping (BookmarkGroup) -> Void) {
        self.frame = frame
        self.onBookmarkClick = onBookmarkClick
        self.viewModel = BookmarksViewModel.shared
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack {
                Text("your_library".localizedString(identifier: Locale.current.identifier, bundle: Bundle.bookmarks))
                    .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.primary)
                    .textStyle(TypographyTokens.TitleLarge)
                
                Spacer()
                
                Text("new_list".localizedString(identifier: Locale.current.identifier, bundle: Bundle.bookmarks))
                    .textStyle(TypographyTokens.HeadlineSmall)
                    .FollowableTopicTag(
                        followed: true,
                        onClick: {
                            SheetUiState.shared.previousSheet = nil
                            SheetUiState.shared.currentSheet = .createBoomark(retainPrevious: false)
                        },
                        enabled: false)
                    .padding(.trailing, isTablet ? 32 : geometry.safeAreaInsets.trailing)
            }
            .edgesIgnoringSafeArea(.leading)
            .padding(.bottom, 10)
            
            ForEach(BookmarkGroupLocation.allCases, id:\.id) { location in
                BookmarkGroupGrid(
                    bookmarksState: viewModel.bookmarksUiState,
                    location: location,
                    onClick: onBookmarkClick,
                    onRemoveClick: viewModel.remove,
                    onEditClick: viewModel.edit,
                    frame: Frame(bounds: .zero))
            }
        }
        .onAppear { viewModel.updateBookmarkGroups() }
        .onRotate(perform: { newOrientation in
            if newOrientation.isValidInterfaceOrientation &&
                newOrientation != .faceUp && newOrientation != .faceDown &&
                newOrientation != orientation {
                viewModel.updateBookmarkGroups()
            }
        })
        .padding(.leading,
                 isTablet ? Offset.shared.value :
                    (orientation.isPortrait ? (geometry.safeAreaInsets.leading) : Offset.shared.value))
        .frame(width: UIScreen.main.bounds.width)
        .fixedSize(horizontal: true, vertical: true)
        .modifier(SizeModifier())
        .onPreferenceChange(SizePreferenceKey.self) { value in
            guard value.width != 0 && value.height != 0 else { return }
            tmpSize = value
            
            DispatchQueue.main.async {
                if tmpSize == value && frame.bounds.size != value {
                    frame.bounds.size = value
                    frame.objectWillChange.send()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
