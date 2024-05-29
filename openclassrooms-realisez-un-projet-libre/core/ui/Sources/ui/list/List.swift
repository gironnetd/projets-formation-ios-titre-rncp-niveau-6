//
//  OlaList.swift
//  ui
//
//  Created by Damien Gironnet on 04/12/2023.
//

import SwiftUI
import common
import model
import designsystem

public struct OlaList<Data: Collection, Content: View>: View where Data.Element: Identifiable {
    
    @ObservedObject private var frame: Frame
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    @State var tmpSize: CGSize = .zero
    
    private let elements: [Data.Element]
    private let content: (Data.Element) -> Content
    
    public init(elements: [Data.Element],
                frame: Frame,
                content: @escaping (Data.Element) -> Content) {
        self.frame = frame
        self.elements = elements
        self.content = content
    }
    
    public var body: some View {
        LazyVStack(spacing: .zero) {
            ForEach(elements) { element in content(element) }
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

public class QuotesUiState: ObservableObject, Equatable {
    public static func == (lhs: QuotesUiState, rhs: QuotesUiState) -> Bool {
        lhs.state == rhs.state
    }
    
    @Published public var state: QuotesState
    
    public init(state: QuotesState) {
        self.state = state
    }
}

public enum QuotesState : Equatable {
    public static func == (lhs: QuotesState, rhs: QuotesState) -> Bool {
        switch(lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.InProgress, .InProgress):
            return true
        case (.Success(let lhsQuotes), .Success(let rhsQuotes)):
            return lhsQuotes == rhsQuotes
        default:
            return false
        }
    }
    
    case Loading
    case InProgress
    case Success(feed: [UserQuote])
}

public class PicturesUiState: ObservableObject, Equatable {
    public static func == (lhs: PicturesUiState, rhs: PicturesUiState) -> Bool {
        lhs.state == rhs.state
    }
    
    @Published public var state: PicturesState
    
    public init(state: PicturesState) {
        self.state = state
    }
}

public enum PicturesState: Equatable {
    public static func == (lhs: PicturesState, rhs: PicturesState) -> Bool {
        switch(lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.Success(let lhsPictures), .Success(let rhsPictures)):
            return lhsPictures == rhsPictures
        default:
            return false
        }
    }
    
    case Loading
    case Success(feed: [UserPicture])
}
