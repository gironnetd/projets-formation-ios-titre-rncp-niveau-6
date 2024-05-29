//
//  UserResourceGrid.swift
//  ui
//
//  Created by Damien Gironnet on 05/12/2023.
//

import SwiftUI
import domain
import common
import designsystem
import navigation
import Factory
import model

///
/// Structure representing picture list
///
public struct UserResourceGrid<Data: Collection, Content: View>: View where Data.Element: UserResource {
    
    @StateObject private var orientation: Orientation = Orientation.shared
    
    @ObservedObject private var offset: Offset = Offset.shared
    
    @Environment(\.geometry) private var geometry
    
    @State var tmpSize: CGSize = .zero
    
    private let elements: [Data.Element]
    private let onToggleBookmark: (Data.Element) -> Void
    private let content: (Data.Element) -> Content
    private let frame: Frame
    
    public init(elements: [Data.Element],
                onToggleBookmark: @escaping (Data.Element) -> Void,
                frame: Frame,
                content: @escaping (Data.Element) -> Content) {
        self.elements = elements
        self.onToggleBookmark = onToggleBookmark
        self.frame = frame
        self.content = content
    }
    
    public var body: some View {
            if isTablet {
                VerticalStaggeredGrid<[Data.Element], Content>(
                    columns: Columns(
                        columns: elements.map { element in
                            ColumnElement(
                                uid: element.uid,
                                content: content(element))
                        },
                        numberOfColumns: isTablet && orientation.current.isLandscape ? 3 : 2
                    ),
                    computationTimes: 1)
                .padding(.leading, isTablet ? Offset.shared.value :
                            (orientation.current.isPortrait ?
                             (geometry.safeAreaInsets.leading) : 12.0))
                .padding(.trailing, 48.0)
                .padding(.bottom, isTablet ? geometry.safeAreaInsets.bottom : 16)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
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
            } else {
                if orientation.current.isPortrait {
                    OlaList<[Data.Element], Content>(
                        elements: elements,
                        frame: frame,
                        content: { element in content(element) })
                } else {
                    VerticalStaggeredGrid<[Data.Element], Content>(
                        columns: Columns(
                            columns: elements.map { element in
                                ColumnElement(
                                    uid: element.uid,
                                    content: content(element))
                            },
                            numberOfColumns: isTablet && orientation.current.isLandscape ? 3 : 2
                        ),
                        computationTimes: isTablet || orientation.current.isLandscape ? 1 : 1)
                    .padding(.leading, isTablet ? Offset.shared.value :
                                (orientation.current.isPortrait ?
                                 (geometry.safeAreaInsets.leading) : 12.0))
                    .padding(.trailing, 48.0)
                    .padding(.bottom, isTablet ? 0.0 : 16)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
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
                }
            }
    }
}

