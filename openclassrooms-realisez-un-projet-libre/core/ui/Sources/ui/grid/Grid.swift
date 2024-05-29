//
//  OlaGrid.swift
//  ui
//
//  Created by Damien Gironnet on 06/10/2023.
//

import SwiftUI
import model
import designsystem
import common

///
/// Structure representing OnelittleAngel grid
///
public struct OlaGrid: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @StateObject private var orientation: Orientation = Orientation.shared
    
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject public var filters: Filter
    @ObservedObject private var frame: Frame
    
    @State var tmpSize: CGSize = .zero
    
    private let texts: [String]
    private let onClick: (String, Bool) -> Void
    
    public init(texts: [String],
                filters: Filter = Filter(),
                onClick: @escaping (String, Bool) -> Void,
                frame: Frame) {
        self.texts = texts
        self.onClick = onClick
        self.filters = filters
        self.frame = frame
    }
    
    var filterTag: (String, Filter) -> FilterTag = { authorBook, filters in
        if !filters.tags.map({ tag in tag.text }).contains(authorBook) {
            let _ = filters.tags.append(
                FilterTag(
                    text: authorBook,
                    enabled: false,
                    font: TypographyTokens.BodyLarge.customFont.uiFont,
                    onClick: {}))
        }
        return filters.tags[filters.tags.map({ tag in tag.text }).firstIndex(of: authorBook)!]
    }
    
    public var body: some View {
        FlexibleGrid(
            availableWidth:
                isTablet ? (geometry.bounds.width - Offset.shared.value * 2 - 48)
            : (orientation.current.isPortrait ? (geometry.bounds.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                (geometry.bounds.width - Offset.shared.value - geometry.safeAreaInsets.trailing)),
            data: texts.indices,
            spacing: isTablet ? 6 : 3,
            alignment: .center)
        { index in
            filterTag(texts[index], filters)
                .onTapGesture {
                    withAnimation {
                        let filter = filters.tags[filters.tags.map({ tag in tag.text}).firstIndex(of: texts[index])!]
                        
                        if !filter.tag.followed.value {
                            filters.tags.filter({ $0.tag.followed.value && $0.text != texts[index] }).first?.tag.followed.value = false
                            filter.tag.followed.value = !filter.tag.followed.value
                        }
                        
                        onClick(texts[index], filter.tag.followed.value)
                    }
                }
        }
        .padding(.leading, isTablet ? Offset.shared.value :  (orientation.current.isPortrait ? (0.0) : 16))
        .padding(.bottom, 16)
        .frame(width: UIScreen.main.bounds.width)
        .modifier(SizeModifier())
        .onPreferenceChange(SizePreferenceKey.self) { value in
            guard value.width != 0 && value.height != 0 else { return }
            tmpSize = value
            
            DispatchQueue.main.async {
                if tmpSize == value && frame.bounds.size != value {
                    if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                    frame.bounds.size = value
                    frame.objectWillChange.send()
                }
            }
        }
        .edgesIgnoringSafeArea(.leading)
    }
}

public class FaithsUiState: ObservableObject {
    @Published public var state: FaithsState

    public init(state: FaithsState) {
        self.state = state
    }
}

public enum FaithsState {
    case Loading
    case InProgress
    case Success(feed: [UserFaith])
}
