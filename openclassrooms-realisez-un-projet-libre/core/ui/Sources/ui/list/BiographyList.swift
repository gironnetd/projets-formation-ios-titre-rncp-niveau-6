//
//  BiographyList.swift
//  ui
//
//  Created by Damien Gironnet on 09/08/2023.
//

import SwiftUI
import domain
import common
import designsystem
import navigation
import Factory
import model

///
/// Structure representing biography list
///
public struct BiographyList: View {
    
    @Environment(\.geometry) private var geometry
    
    @StateObject private var orientation: Orientation = Orientation.shared
    private let frame: Frame
    
    @State var tmpSize: CGSize = .zero
    
    private let biography: UserBiography
    private let onToggleBookmark: (UserResource) -> Void
        
    public init(biography: UserBiography,
                onToggleBookmark: @escaping (UserResource) -> Void,
                frame: Frame) {
        self.biography = biography
        self.onToggleBookmark = onToggleBookmark
        self.frame = frame
    }
    
    public var body: some View {
        BiographyCard(biography: biography, onToggleBookmark: onToggleBookmark)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading,
                     isTablet ? Offset.shared.value :
                        (orientation.current.isPortrait ?
                         (geometry.safeAreaInsets.leading) : Offset.shared.value))
            .padding(.trailing, isTablet ? 48 : geometry.safeAreaInsets.trailing)
            .frame(width: UIScreen.main.bounds.width)
            .padding(.bottom, isTablet ? 0.0 : 16)
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

public class BiographyUiState: ObservableObject, Equatable {
    public static func == (lhs: BiographyUiState, rhs: BiographyUiState) -> Bool {
        lhs.state == rhs.state
    }
    
    @Published public var state: BiographyState
    
    public init(state: BiographyState) {
        self.state = state
    }
}

public enum BiographyState: Equatable {
    public static func == (lhs: BiographyState, rhs: BiographyState) -> Bool {
        switch(lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.Success(let lhsBiography), .Success(let rhsBiography)):
            return lhsBiography == rhsBiography
        default:
            return false
        }
    }
    
    case Loading
    case Success(feed: UserBiography)
}

public class BiographiesUiState: ObservableObject {
    @Published public var state: BiographiesState
    
    public init(state: BiographiesState) {
        self.state = state
    }
}

public enum BiographiesState : Equatable {
    public static func == (lhs: BiographiesState, rhs: BiographiesState) -> Bool {
        switch(lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.Success(let lhsBiographies), .Success(let rhsBiographies)):
            return lhsBiographies == rhsBiographies
        default:
            return false
        }
    }
    
    case Loading
    case Success(feed: [UserBiography])
}
