//
//  UsernameTextField.swift
//  designsystem
//
//  Created by Damien Gironnet on 12/02/2023.
//

import SwiftUI
import common
import model
import FloatingLabelTextFieldSwiftUI
//import DevicePpi

///
/// Structure for username text field
///
public struct UsernameTextField: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.colorScheme) internal var colorScheme
    @Environment(\.locale) private var locale
    
    @ObservedObject public var username: ValueTextField = ValueTextField()
    
    @State private var size: CGSize = .zero
    
    public init() {}
    
    public var body: some View {
        HStack(alignment: .center,
               spacing:
                (UIScreen.inches > 4.7 ?
                 CGFloat(10.0).adjustHeight() :
                  10.0 * (UIScreen.main.nativeBounds.height) / 2796)) {

            FloatingLabelTextField($username.value,
                                   placeholder: "type_username".localizedString(identifier: locale.identifier, bundle: Bundle.designsystem),
                                   editingChanged: { _ in }) {}
            .floatingStyle(ThemeTextFieldStyle(localColorScheme: localColorScheme))
            .frame(height: isTablet ? 50 : 45)
            .padding(.horizontal, 16)
            .keyboardType(.emailAddress)
            .accentColor(localColorScheme.onPrimaryContainer)
            .padding(
                .bottom,
                     (UIScreen.inches > 4.7 ?
                      CGFloat(4.0).adjustHeight() :
                       4.0 * (UIScreen.main.nativeBounds.height) / 2796)
            )
        }
        .padding(
            .top,
                 (UIScreen.inches > 4.7 ?
                  CGFloat(6.0).adjustHeight() :
                   6.0 * (UIScreen.main.nativeBounds.height) / 2796)
        )
        .padding(
            .bottom,
                 (UIScreen.inches > 4.7 ?
                  CGFloat(4.0).adjustHeight() :
                   4.0 * (UIScreen.main.nativeBounds.height) / 2796)
        )
        .modifier(SizeModifier())
        .onPreferenceChange(SizePreferenceKey.self) { value in
            DispatchQueue.main.async {
                self.size = value
            }
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: size.height,
                maxHeight: size.height)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .light ? localColorScheme.primaryContainer.opacity(0.35) : localColorScheme.Primary99)
                .brightness(colorScheme == .light ? 0.0 : -0.03)
                .frame(height: size.height))
    }
}

internal struct UsernameTextField_Previews: PreviewProvider {
    static var previews: some View {
        
        UIElementPreview(UsernameTextField().environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.none,
                         multiLanguage: true,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(UsernameTextField().environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(UsernameTextField().environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(UsernameTextField().environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
    }
}
