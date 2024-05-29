//
//  SaveUserResourceView.swift
//  bookmarks
//
//  Created by Damien Gironnet on 15/10/2023.
//

import SwiftUI
import model
import designsystem
import navigation
import common
import ui

public struct SaveUserResourceView: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.geometry) private var geometry
    
    @ObservedObject private var viewModel: BookmarksViewModel
    @ObservedObject private var userResource: UserResource
    @ObservedObject private var frame: Frame = Frame(bounds: .zero)
        
    public init(_ userResource: UserResource) { 
        self.userResource = userResource
        self.viewModel = BookmarksViewModel.shared
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("save_to".localizedString(identifier: Locale.current.identifier, bundle: Bundle.bookmarks))
                .textStyle(TypographyTokens.BodyLarge)
                .foregroundColor(colorScheme == .light ? localColorScheme.Primary20 : localColorScheme.Primary30)
                .padding(.top, isTablet ? 20 : 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Text("create_bookmark".localizedString(identifier: Locale.current.identifier, bundle: Bundle.bookmarks))
                        .textStyle(TypographyTokens.BodyLarge)
                        .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation { SheetUiState.shared.isShowing = false }
                            SheetUiState.shared.currentSheet = .createBoomark(retainPrevious: true)
                        }
                    
                    if case .Success(let bookmarks) = viewModel.bookmarksUiState.state {
                        VStack(alignment: .leading) {
                            let onShared = bookmarks.filter({ $0.location == .shared })
                            
                            if onShared.isNotEmpty {
                                Text("shared".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem))
                                    .textStyle(TypographyTokens.BodyLarge)
                                    .foregroundColor(colorScheme == .light ? localColorScheme.Primary20 : localColorScheme.Primary30)
                                
                                ForEach(onShared, id: \.id) { group in
                                    BookmarkGroupCheckedBoxButton(
                                        group: group,
                                        resource: userResource,
                                        onClick: { bookmark, isChecked in
                                            viewModel.updateUserResourceBookmarked(bookmark: bookmark, bookmarked: isChecked)
                                            
                                            if !isChecked && !bookmarks/*.filter({ $0.id != bookmark.idBookmarkGroup })*/.flatMap({ $0.bookmarks })
                                                .contains(where: { $0.idResource == bookmark.idResource }) {
                                                userResource.isSaved.value = false
                                            }
                                        })
                                }
                            }
                            
                            let onDevice = bookmarks.filter({ $0.location == .device })
                            if onDevice.isNotEmpty {
                                Text("on_device".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem))
                                    .textStyle(TypographyTokens.BodyLarge)
                                    .foregroundColor(colorScheme == .light ? localColorScheme.Primary20 : localColorScheme.Primary30)
                                
                                ForEach(onDevice, id: \.id) { group in
                                    BookmarkGroupCheckedBoxButton(
                                        group: group,
                                        resource: userResource,
                                        onClick: { bookmark, isChecked in
                                            viewModel.updateUserResourceBookmarked(bookmark: bookmark, bookmarked: isChecked)
                                            
                                            DispatchQueue.main.async {
                                                userResource.isSaved.value = !(!isChecked && !bookmarks.flatMap({ $0.bookmarks })
                                                    .contains(where: { $0.idResource == bookmark.idResource }))

                                            }
                                        })
                                }
                            }
                            
                            let onRemote = bookmarks.filter({ $0.location == .remote })
                            if onRemote.isNotEmpty {
                                Text("from_account".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem))
                                    .textStyle(TypographyTokens.BodyLarge)
                                    .foregroundColor(colorScheme == .light ? localColorScheme.Primary20 : localColorScheme.Primary30)
                                
                                ForEach(onRemote, id: \.id) { group in
                                    BookmarkGroupCheckedBoxButton(
                                        group: group,
                                        resource: userResource,
                                        onClick: { bookmark, isChecked in
                                            viewModel.updateUserResourceBookmarked(bookmark: bookmark, bookmarked: isChecked)
                                            
                                            if !isChecked && !bookmarks.flatMap({ $0.bookmarks })
                                                .contains(where: { $0.idResource == bookmark.idResource }) {
                                                userResource.isSaved.value = false
                                            }
                                        })
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding([.top, .horizontal], 20)
        .padding(.bottom, isTablet ? 44.0 : geometry.safeAreaInsets.bottom)
    }
}
