//
//  CenturyGrid.swift
//  ui
//
//  Created by Damien Gironnet on 17/05/2023.
//

import SwiftUI
import model
import designsystem
import common

///
/// Structure representing century grid
///
public struct CenturyGrid: View {
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    @ObservedObject public var filters: Filter
    @ObservedObject private var frame: Frame
    
    @State var tmpSize: CGSize = .zero
    
    private let centuries: [String]
    private let onClick: (String, Bool) -> Void
    
    public init(centuries: [String],
                filters: Filter,
                onClick: @escaping (String, Bool) -> Void,
                frame: Frame) {
        self.centuries = centuries
        self.onClick = onClick
        self.frame = frame
        self.filters = filters
    }
    
    var filterTag: (String, Filter) -> FilterTag = { century, filters in
        if !filters.tags.map({ tag in tag.text }).contains(century) {
            let _ = filters.tags.append(
                FilterTag(
                    text: century,
                    enabled: false,
                    font: TypographyTokens.BodySmall.customFont.uiFont,
                    onClick: {}))
        }
        return filters.tags[filters.tags.map({ tag in tag.text }).firstIndex(of: century)!]
    }
    
    public var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: isTablet ? 80 : 50))]) {
            ForEach(centuries.indices, id: \.self) { index in
                filterTag(centuries[index], filters)
                    .onTapGesture {
                        withAnimation {
                            let filter = filters.tags[filters.tags.map({ tag in tag.text}).firstIndex(of: centuries[index])!]
                                                            
                            if !filter.tag.followed.value {
                                filters.tags.filter({ $0.tag.followed.value && $0.text != centuries[index] }).first?.tag.followed.value = false
                                filter.tag.followed.value = !filter.tag.followed.value
                            }
                        
                            onClick(centuries[index], filter.tag.followed.value)
                        }
                    }
                    .fixedSize(horizontal: true, vertical: true)
            }
        }
        .frame(
            width:
                isTablet ? (geometry.bounds.width - Offset.shared.value * 2 - geometry.safeAreaInsets.trailing)
            : (orientation.isPortrait ? (geometry.bounds.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                (geometry.bounds.width - Offset.shared.value - geometry.safeAreaInsets.trailing))
        )
        .padding(.leading, isTablet ? Offset.shared.value :  16.0)
        .padding(.trailing, isTablet ? 48 : 16.0)
        .padding(.bottom, 16)
        .frame(width: UIScreen.main.bounds.width)
        .modifier(SizeModifier())
        .onPreferenceChange(SizePreferenceKey.self) { value in
            guard value.width != 0 && value.height != 0 else { return }
            tmpSize = value
            
            DispatchQueue.main.async {
                if tmpSize == value && frame.bounds.size != value {
                    frame.bounds.size = value
                    frame.objectWillChange.send()
                }
            }
        }
        .edgesIgnoringSafeArea(.leading)
        .onAppear {
            if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
        }
    }
}

public class CenturiesUiState: ObservableObject {
    @Published public var state: CenturiesState
    
    public init(state: CenturiesState) {
        self.state = state
    }
}

public enum CenturiesState: Equatable {
    case Loading
    case InProgress
    case Success(feed: [Century])
}
