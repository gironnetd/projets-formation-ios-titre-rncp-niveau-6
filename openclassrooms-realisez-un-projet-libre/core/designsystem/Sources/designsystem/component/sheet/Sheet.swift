//
//  BottomSheet.swift
//  designsystem
//
//  Created by Damien Gironnet on 13/10/2023.
//

import Foundation
import SwiftUI
import model
import Combine
import common

public enum SheetView: Equatable {
    
    public static func == (lhs: SheetView, rhs: SheetView) -> Bool {
        switch(lhs, rhs) {
        case (.authentication, .authentication):
            return true
        case (.createBoomark, .createBoomark):
            return true
        case (.editBookmark, .editBookmark):
            return true
        default:
            return false
        }
    }
    
    case authentication, bookmarks(UserResource), createBoomark(retainPrevious: Bool), editBookmark(BookmarkGroup), addOrEditNote(Bookmark)
}

public class SheetUiState: ObservableObject {
    
    public static var shared: SheetUiState = SheetUiState()
    
    @Published public var isShowing: Bool = false
    
    public var currentSheet: SheetView = .authentication {
        didSet {
            if case .bookmarks(let bookmark) = currentSheet {
                if let previousSheet = previousSheet, previousSheet == currentSheet {
                    self.previousSheet = nil
                } else if !isShowing {
                    previousSheet = .bookmarks(bookmark)
                }
            } else if case .createBoomark(let retainPrevious) = currentSheet, retainPrevious {
                previousSheet = oldValue
            }
            
            isShowing = true
            
            objectWillChange.send()
        }
    }
    
    public var previousSheet: SheetView? = nil

    public init() {}
}

public struct Sheet<Content: View>: View {

    @Environment(\.orientation) private var orientation
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
        
    @Environment(\.colorScheme) private var colorScheme
    
    private let content: Content
    
    @Binding var isShowing: Bool
    
    public init(isShowing: Binding<Bool>,
                @ViewBuilder content: @escaping () -> Content) {
        self._isShowing = isShowing
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        SheetUiState.shared.previousSheet = nil
                        isShowing.toggle()
                    }
                
                content.frame(width: isTablet ? 
                              (orientation.isPortrait ? (UIScreen.main.bounds.width / 1.75) : UIScreen.main.bounds.width / 2.35) :
                                (orientation.isPortrait ? (UIScreen.main.bounds.width) : UIScreen.main.bounds.width / 1.75) )
                    .transition(.move(edge: .bottom))
                    .background(colorScheme == .light ? PaletteTokens.White : localColorScheme.primaryContainer)
                    .brightness(colorScheme == .light ? 0.0 : -0.03)
                    .cornerRadius(8, corners: [.topLeft, .topRight])
                    .keyboardResponsive()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorners(radius: radius, corners: corners) )
    }
}

struct RoundedCorners: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
