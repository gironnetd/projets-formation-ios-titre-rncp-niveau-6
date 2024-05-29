//
//  Page.swift
//  designsystem
//
//  Created by Damien Gironnet on 07/09/2023.
//

import Foundation
import SwiftUI
import Combine

public class Proxy: ObservableObject {
    @Published public var value: GeometryProxy?
    
    public init() {}
}

public protocol Views {}

public class Page<T: Views>: ObservableObject {
    public let title: String
    public let view: T
    @Published public var frame: Frame
    public var isSwipeable: Bool = true
    
    var anyCancellable: AnyCancellable? = nil
    
    public init(title: String, view: T) {
        self.title = title
        self.view = view
        self.frame = Frame(bounds: .zero)
        
        anyCancellable = self.frame.objectWillChange.sink { [weak self] (_) in
            if self?.frame.bounds.size != .zero {
                self?.objectWillChange.send()
            }
        }
    }
}

open class Pages<T: Views>: ObservableObject {
    @Published public var title: String = ""
    
    open var index: (currentIndex: Int, previousIndex: Int) {
        willSet { objectWillChange.send() }
        didSet {
            index.previousIndex = oldValue.currentIndex
        }
    }
        
    @Published public var pages: [Page<T>] = []
    
    public var cancellables: Set<AnyCancellable> = Set()
    
    public init(currentIndex: Int, previousIndex: Int) {
        index = (currentIndex, previousIndex)
    }
}
