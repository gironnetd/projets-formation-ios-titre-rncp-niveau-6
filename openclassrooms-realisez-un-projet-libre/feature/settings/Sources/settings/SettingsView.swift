//
//  SettingsView.swift
//  settings
//
//  Created by Damien Gironnet on 05/04/2023.
//

import Foundation
import SwiftUI
import common
import designsystem
import ui
import model
import remote
import navigation
import Combine

///
/// Structure representing the View for the settings screen
///
public struct SettingsView: View, OlaTab {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @EnvironmentObject private var localGradientColors: GradientColors
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.geometry) private var geometry
    @Environment(\.orientation) private var orientation
    
    public static let title: String  = "settings".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings)
    
    @ObservedObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @ObservedObject private var frame: Frame
    
    @State var tmpSize: CGSize = .zero
    
    public init(frame: Frame) {
        self.frame = frame
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading) {
                Text("user_login".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings))
                    .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer)
                    .textStyle(TypographyTokens.TitleLarge)
                    .padding(.bottom, 8)
                
                Toggle(isOn: Binding(
                    get: { viewModel.user.providerID.isNotEmpty },
                    set: { _ in
                        if viewModel.user.providerID.isNotEmpty  {
                            viewModel.user.providerID = ""
                            Task {
                                SheetUiState.shared.previousSheet = nil
                                try await viewModel.signOut()
                            }
                        } else {
                            SheetUiState.shared.currentSheet = SheetView.authentication
                        }
                    }),
                       label: {
                    HStack(alignment: .center, spacing: 20) {
                        if viewModel.user.providerID.isNotEmpty {
                            switch AuthProvider(rawValue: viewModel.user.providerID) {
                            case .apple:
                                OlaIcons.Apple.resizable()
                                    .aspectRatio(AspectRatio.Apple.value, contentMode: .fit)
                                    .frame(height: 24)
                            case .facebook:
                                OlaIcons.Facebook.resizable()
                                    .aspectRatio(AspectRatio.Facebook.value, contentMode: .fit)
                                    .frame(height: 24)
                            case .twitter:
                                OlaIcons.Twitter.resizable().frame(width: 24, height: 24)
                            case .google:
                                OlaIcons.Google.resizable().frame(width: 24, height: 24)
                            default:
                                OlaIcons.User.frame(width: 24, height: 24).foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer)
                            }
                            
                            if viewModel.user.displayName != nil && viewModel.user.email != nil {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(viewModel.user.displayName!)
                                        .foregroundColor(colorScheme == .light ? localColorScheme.Primary20 : localColorScheme.onPrimaryContainer)
                                        .textStyle(TypographyTokens.BodyLarge)
                                    
                                    Text(viewModel.user.email!)
                                        .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.Primary20)
                                        .textStyle(TypographyTokens.BodyMedium)
                                }
                            } else if viewModel.user.displayName != nil && viewModel.user.email == nil {
                                Text(viewModel.user.displayName!)
                                    .foregroundColor(localColorScheme.Primary20)
                                    .textStyle(TypographyTokens.BodyLarge)
                            } else if viewModel.user.email != nil && viewModel.user.displayName == nil {
                                Text(viewModel.user.email!)
                                    .foregroundColor(localColorScheme.Primary20)
                                    .textStyle(TypographyTokens.BodyLarge)
                            }
                            
                        } else {
                            OlaIcons.User.frame(width: 24, height: 24).foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer)
                            
                            Text("no_user_logged_in".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings))
                                .foregroundColor(localColorScheme.Primary20)
                                .textStyle(TypographyTokens.BodyLarge)
                        }
                    }
                })
                .toggleStyle(SwitchToggleStyle(tint: colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary30))
                .accentColor(localColorScheme.Primary20)
                .frame(height: 40)
            }
            .frame(alignment: .leading)
            .padding(.trailing, isTablet ? 32 : 0)
            
            VStack(alignment: .leading) {
                Text("theme".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings))
                    .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer)
                    .textStyle(TypographyTokens.TitleLarge)
                    .padding(.bottom, 8)
                
                RadioButtonGroup(
                    orientation: .vertical,
                    radioButtons: ThemeBrand.allCases.enumerated().map { index, theme in
                        RadioButton(
                            label: theme.description,
                            selectedRadioButton: $viewModel.settingsUiState.brand,
                            onClick: { themeName in
                                if let themeBrand = ThemeBrand(rawValue: themeName) {
                                    viewModel.settingsUiState.brand = themeName
                                    Task {
                                        do {
                                            try await self.viewModel.updateThemeBrand(themeBrand: themeBrand)
                                        } catch { }
                                    }
                                    
                                    localColorScheme.themeBrand = themeBrand
                                    localGradientColors.bottom = localColorScheme.Primary99
                                }
                            })
                    })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text("dark_mode_preference".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings))
                    .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer)
                    .textStyle(TypographyTokens.TitleLarge)
                    .padding(.bottom, 8)
                
                RadioButtonGroup(
                    orientation: .vertical,
                    radioButtons: DarkThemeConfig.allCases.enumerated().map { index, theme in
                        RadioButton(
                            label: theme.description,
                            selectedRadioButton: $viewModel.settingsUiState.darkThemeConfig,
                            onClick: { darkThemeConfigName in
                                if let darkThemeConfig = DarkThemeConfig(rawValue: darkThemeConfigName) {
                                    viewModel.settingsUiState.darkThemeConfig = darkThemeConfigName
                                    
                                    Task {
                                        do {
                                            try await self.viewModel.updateDarkThemeConfig(darkThemeConfig: darkThemeConfig)
                                        } catch {}
                                    }
                                    
                                    switch darkThemeConfig {
                                    case .systemDefault:
                                        UIApplication.shared.currentKeyWindow?.rootViewController?.view.overrideUserInterfaceStyle = .unspecified
                                    case .light:
                                        UIApplication.shared.currentKeyWindow?.rootViewController?.view.overrideUserInterfaceStyle = .light
                                    case .dark:
                                        UIApplication.shared.currentKeyWindow?.rootViewController?.view.overrideUserInterfaceStyle = .dark
                                    }
                                }
                            })
                    })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 10)
        .padding(.leading,
                 isTablet ? Offset.shared.value :
                    (orientation.isPortrait ?
                     (geometry.safeAreaInsets.leading) : Offset.shared.value))
        .padding(.trailing, geometry.safeAreaInsets.trailing)
        .frame(width: UIScreen.main.bounds.width)
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
