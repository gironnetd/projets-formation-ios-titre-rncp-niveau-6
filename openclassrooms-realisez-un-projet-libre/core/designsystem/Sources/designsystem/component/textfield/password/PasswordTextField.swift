//
//  PasswordTextField.swift
//  designsystem
//
//  Created by Damien Gironnet on 12/02/2023.
//

import SwiftUI
import common
import model
import FloatingLabelTextFieldSwiftUI

///
/// Structure for password text field
///
public struct PasswordTextField: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.colorScheme) internal var colorScheme
    @Environment(\.locale) private var locale
    
    @ObservedObject public var password: ValueTextField = ValueTextField()
    @ObservedObject private var isEdited: EditedTextField = EditedTextField()
    
    @State private var size: CGSize = .zero
    @State private var isPasswordShow: Bool = false
    
    private let passwordType: PasswordType
    
    public init(passwordType: PasswordType) {
        self.passwordType = passwordType
    }
    
    public var body: some View {
        HStack(alignment: .center,
               spacing:
                (UIScreen.inches > 4.7 ?
                 CGFloat(10.0).adjustHeight() :
                    10.0 * (UIScreen.main.nativeBounds.height) / 2796)) {

            FloatingLabelTextField($password.value,
                                   placeholder: passwordType.rawValue.localizedString(identifier: locale.identifier, bundle: Bundle.designsystem),
                                   editingChanged: { _ in
                if #unavailable(iOS 16) {
                    if self.password.value.isEmpty {
                        self.isEdited.value.toggle()
                    } else {
                        self.isEdited.value = true
                    }
                }
            }) {
                if #unavailable(iOS 16) {
                    if self.password.value.isNotEmpty {
                        self.isEdited.value = true
                    } else {
                        self.isEdited.value = false
                    }
                }
            }
            .isSecureTextEntry(!self.isPasswordShow)
            .floatingStyle(ThemeTextFieldStyle(localColorScheme: localColorScheme))
            .frame(height: isTablet ? 50 : 45)
            .padding(.leading, 16)
            .keyboardType(.default)
            .accentColor(localColorScheme.onPrimaryContainer)
            .padding(
                .bottom,
                (UIScreen.inches > 4.7 ?
                 CGFloat(4.0).adjustHeight() :
                    4.0 * (UIScreen.main.nativeBounds.height) / 2796)
            )
            
            Button(action: { self.isPasswordShow.toggle() }) {
                (self.isEdited.value == true  ?
                 Image(systemName: self.isPasswordShow ? "eye.slash.fill" :"eye.fill")
                    .accentColor(localColorScheme.onPrimaryContainer) :
                    Image(systemName: self.isPasswordShow ? "eye.slash.fill" :"eye.fill")
                    .accentColor(localColorScheme.primary)
                )
                .padding(
                    .trailing,
                    (UIScreen.inches > 4.7 ?
                     CGFloat(16.0).adjustHeight() :
                        16.0 * (UIScreen.main.nativeBounds.height) / 2796)
                )
            }.frame(alignment: .top)
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

internal struct ConfirmPasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        
        UIElementPreview(PasswordTextField(passwordType: .enter).environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.none,
                         multiLanguage: true,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(PasswordTextField(passwordType: .enter).environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(PasswordTextField(passwordType: .enter).environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(PasswordTextField(passwordType: .enter).environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
    }
}
