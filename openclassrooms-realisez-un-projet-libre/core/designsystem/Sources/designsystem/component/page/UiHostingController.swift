//
//  UiHostingController.swift
//  designsystem
//
//  Created by Damien Gironnet on 12/06/2023.
//

import Foundation
import SwiftUI
import common
import UIKit

///
/// Class for implementation for custom UIHostingController
///
public class UiHostingController<Content>: UIHostingController<Content> where Content: View {
    
    public override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        self.view.backgroundColor = .clear
    }
    
    public override var shouldAutorotate: Bool {
        return false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
        self.view.sizeToFit()
    }
}
