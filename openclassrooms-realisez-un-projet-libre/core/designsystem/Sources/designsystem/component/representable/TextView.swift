//
//  OlaTextView.swift
//  designsystem
//
//  Created by Damien Gironnet on 03/11/2023.
//

import Foundation
import SwiftUI
import UIKit

public struct OlaTextView: UIViewRepresentable {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared

    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var text: String
    private let placeholder: String
    private let onTextDidChanged: () -> Void
    
    public init(text: Binding<String>, placeholder: String, onTextDidChanged: @escaping () -> Void) {
        self._text = text
        self.placeholder = placeholder
        self.onTextDidChanged = onTextDidChanged
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator

        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isNotEmpty {
            uiView.text = text
            uiView.textColor = colorScheme == .light ? UIColor(localColorScheme.onPrimaryContainer) :
            UIColor(localColorScheme.onPrimaryContainer)
            uiView.font = TypographyTokens.BodyLarge.customFont.uiFont
        } else {
            uiView.text = placeholder
            uiView.textColor = colorScheme == .light ? UIColor(localColorScheme.primary) :
            UIColor(localColorScheme.Primary20)
            uiView.font = TypographyTokens.TitleSmall.customFont.uiFont
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator($text, placeholder: placeholder, onTextDidChanged: onTextDidChanged)
    }
     
    public class Coordinator: NSObject, UITextViewDelegate {
        
        private var localColorScheme: OlaColorScheme = OlaColorScheme.shared
        
        @Environment(\.colorScheme) private var colorScheme
        
        private var text: Binding<String>
        private let placeholder: String
        private let onTextDidChanged: () -> Void

        init(_ text: Binding<String>, placeholder: String, onTextDidChanged: @escaping () -> Void) {
            self.text = text
            self.placeholder = placeholder
            self.onTextDidChanged = onTextDidChanged
        }
     
        public func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
            onTextDidChanged()
        }
        
        public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            textView.resignFirstResponder()
            return true
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == placeholder {
                textView.text = nil
                textView.textColor = UIColor(localColorScheme.onPrimaryContainer)
                textView.font = TypographyTokens.BodyLarge.customFont.uiFont
            }
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholder
                textView.textColor = colorScheme == .light ? UIColor(localColorScheme.primary) :
                UIColor(localColorScheme.Primary20)
                textView.font = TypographyTokens.TitleSmall.customFont.uiFont
            }
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
}

extension UITextView {
 
    func addDoneButton(title: String, target: Any, selector: Selector) {
 
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
 
    @objc func doneButtonTapped(button: UIBarButtonItem) {
        self.resignFirstResponder()
    }
}
 
