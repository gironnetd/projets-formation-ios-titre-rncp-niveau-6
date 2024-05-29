//
//  PopoverContentViewController.swift
//  designsystem
//
//  Created by Damien Gironnet on 21/10/2023.
//

import Foundation
import UIKit
import SwiftUI
import common

public class PopoverContentViewController<V>: UIHostingController<V>, UIPopoverPresentationControllerDelegate where V: View {
    
    private var isPresented: Binding<Bool>
    fileprivate var size: CGSize = .zero

    public init(rootView: V, isPresented: Binding<Bool>) {
        self.isPresented = isPresented
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let size = sizeThatFits(in: UIView.layoutFittingExpandedSize)
        preferredContentSize = size
    }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.isPresented.wrappedValue = false
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension UIView {
    var closestVC: UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}

public struct AlwaysPopoverModifier<PopoverContent>: ViewModifier where PopoverContent: View {
    
    let isPresented: Binding<Bool>
    let contentBlock: PopoverContent
    
    public struct Store {
        var anchorView = UIView()
        
        public init() {}
    }
    
    @State private var store = Store()
    
    public init(isPresented: Binding<Bool>, contentBlock: @escaping () -> PopoverContent, store: AlwaysPopoverModifier<PopoverContent>.Store = Store()) {
        self.isPresented = isPresented
        self.contentBlock = contentBlock()
        self.store = store
    }

    public func body(content: Content) -> some View {
        presentPopover()
        return content.background(InternalAnchorView(uiView: store.anchorView))
    }

    private func presentPopover() {
        if isPresented.wrappedValue {
            let contentController = PopoverContentViewController(rootView: contentBlock, isPresented: isPresented)
            contentController.modalPresentationStyle = .popover
            
            let view = store.anchorView
            guard let popover = contentController.popoverPresentationController else { return }
            popover.sourceView = view
            popover.permittedArrowDirections = []
            let position = CGRectMake(view.bounds.origin.x - view.bounds.size.width / 2,
                                      view.bounds.origin.y + view.bounds.size.height / 2,
                                      view.bounds.size.width,
                                      view.bounds.size.height)
            popover.sourceRect = position
            popover.delegate = contentController
            
            guard let sourceVC = view.closestVC else { return }
            
            if let presentedVC = sourceVC.presentedViewController {
                presentedVC.dismiss(animated: true) {
                    sourceVC.present(contentController, animated: true)
                }
            } else {
                sourceVC.present(contentController, animated: true)
            }
        } else {
            guard let sourceVC = store.anchorView.closestVC else { return }
            
            sourceVC.dismiss(animated: true)
        }
    }
}

private struct InternalAnchorView: UIViewRepresentable {
    typealias UIViewType = UIView
    let uiView: UIView

    func makeUIView(context: Self.Context) -> Self.UIViewType {
        uiView
    }

    func updateUIView(_ uiView: Self.UIViewType, context: Self.Context) { }
}

extension View {
    public func alwaysPopover<Content>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
            self.modifier(AlwaysPopoverModifier(isPresented: isPresented, contentBlock: content))
    }
}
