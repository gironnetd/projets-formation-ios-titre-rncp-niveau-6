//
//  ForyouView.swift
//  foryou
//
//  Created by Damien Gironnet on 05/04/2023.
//

import Foundation
import SwiftUI
import common
import designsystem
import ui
import domain
import navigation
import Factory
import model

///
/// Structure representing the View for the foryou screen
///
public struct ForyouView: View, OlaTab {
    
    /// EnvironmentObject for application color scheme
    @ObservedObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    /// EnvironmentObject for orientation
    @StateObject private var orientation: Orientation = Orientation.shared
    
    /// StateObject for the ForyouView ViewModel
    @ObservedObject private var viewModel: ForyouViewModel = ForyouViewModel()
    
    /// ObservedObject for the offset depending on device type
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var frame: Frame
    
    /// Environment value for GeometryReader
    @Environment(\.colorScheme) private var colorScheme
    
    /// Environment value for color scheme
    @Environment(\.geometry) private var geometry
    
    /// Static variable for title of screen
    public static let title: String = "foryou".localizedString(identifier: Locale.current.identifier, bundle: Bundle.foryou)
    
    @State private var tmpSize: CGSize = .zero
    
    public init(frame: Frame) { self.frame = frame }
    
    /// Computed property used to display foryou quotes title
    private var foryouQuotesHeading: some View {
        HStack {
            Text("foryou_quote".localizedString(identifier: Locale.current.identifier, bundle: Bundle.foryou))
                .foregroundColor(localColorScheme.Primary20)
                .textStyle(TypographyTokens.TitleLarge)
            
            Spacer()
            
            if !isTablet && orientation.current.isPortrait {
                OlaIcons.ArrowRight.foregroundColor(localColorScheme.Primary20)
            }
        }
    }
    
    /// Computed property used to display foryou pictures title
    private var foryouPicturesHeading: some View {
        HStack {
            Text("foryou_picture".localizedString(identifier: Locale.current.identifier, bundle: Bundle.foryou))
                .foregroundColor(localColorScheme.Primary20)
                .textStyle(TypographyTokens.TitleLarge)
            
            Spacer()
            
            if !isTablet && orientation.current.isPortrait {
                OlaIcons.ArrowRight.foregroundColor(localColorScheme.Primary20)
            }
        }
    }
    
    /// Computed property used to display foryou biographies title
    private var foryouBiographiesHeading: some View {
        HStack {
            Text("foryou_biography".localizedString(identifier: Locale.current.identifier, bundle: Bundle.foryou))
                .foregroundColor(localColorScheme.Primary20)
                .textStyle(TypographyTokens.TitleLarge)
            
            Spacer()
            
            if !isTablet && orientation.current.isPortrait {
                OlaIcons.ArrowRight.foregroundColor(localColorScheme.Primary20)
            }
        }
    }
    
    public var body: some View {
        VStack {
            let quotesState = viewModel.quotesUiState.value.state
            if case .Success(let quotes) = quotesState {
                foryouQuotesHeading.padding(.vertical, 6)
                    .padding(.leading, isTablet ? offset.value : (orientation.current.isPortrait ? (geometry.safeAreaInsets.leading) : offset.value))
                    .padding(.trailing, isTablet ? 16.0 : geometry.safeAreaInsets.trailing)
                
                ForyouQuotesGrid(
                    quotes: quotes,
                    onToggleBookmark: viewModel.onToggleBookmark,
                    onTopicClick: viewModel.onTopicClick)
                .fixedSize(horizontal: false, vertical: true)
            }
            
            let picturesState = viewModel.picturesUiState.value.state
            if case .Success(let pictures) = picturesState {
                foryouPicturesHeading.padding(.vertical, 6)
                    .padding(.leading, isTablet ? offset.value : (orientation.current.isPortrait ? (geometry.safeAreaInsets.leading) : offset.value))
                    .padding(.trailing, isTablet ? 16.0 : geometry.safeAreaInsets.trailing)
                
                ForyouPicturesGrid(
                    pictures: pictures,
                    onToggleBookmark: viewModel.onToggleBookmark,
                    onTopicClick: viewModel.onTopicClick)
                .fixedSize(horizontal: false, vertical: true)
            }
            
            let biographiesState = viewModel.biographiesUiState.value.state
            if case .Success(let biographies) = biographiesState {
                foryouBiographiesHeading.padding(.vertical, 6)
                    .padding(.leading, isTablet ? offset.value : (orientation.current.isPortrait ? (geometry.safeAreaInsets.leading) : offset.value))
                    .padding(.trailing, isTablet ? 16.0 : geometry.safeAreaInsets.trailing)
                
                ForyouBiographiesGrid(
                    biographies: biographies,
                    onToggleBookmark: viewModel.onToggleBookmark,
                    onTopicClick: viewModel.onTopicClick)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .animation(nil)
        .onAppear {
            viewModel.hasDateChanged()
            viewModel.updateForyou()
        }
        .frame(width: UIScreen.main.bounds.width)
        .modifier(SizeModifier())
        .onPreferenceChange(SizePreferenceKey.self) { value in
            guard value.width != 0 && value.height != 0 else { return }
            tmpSize = value
            
            DispatchQueue.main.async {
                if tmpSize == value && frame.bounds.size != value {
                    frame.bounds.size = value
                    frame.objectWillChange.send()
                    if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
