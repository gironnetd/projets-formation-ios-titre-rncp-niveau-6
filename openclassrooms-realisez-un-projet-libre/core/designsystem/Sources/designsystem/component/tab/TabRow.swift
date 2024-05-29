//
//  TabRow.swift
//  designsystem
//
//  Created by damien on 19/09/2022.
//

import SwiftUI
import common

///
/// ObservableObject used to know offset in application
///
public class Offset: ObservableObject {
    @Published public var value: CGFloat
    
    public init() {
        value = Offset.shared.value
    }
    
    public init(value: CGFloat) {
        self.value = value
    }
    
    public static let shared = Offset(value: .zero)
    
    public static func set(_ offset: CGFloat) {
        Offset.shared.value = offset
    }
}

public var tabRowHeight: CGFloat = isTablet ? 65.0 : 55.0

///
/// Structure representing Tab row in application
///
public struct OlaTabRow<Content: View>: View {
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    @StateObject private var offset: Offset = Offset()
    @StateObject public var size: OlaTabRowSize = OlaTabRowSize()
    @Binding private var selectedTabIndex: Int
    
    private let fixed: Bool
    private let centerAnchor: Bool
    private let isVertical: Bool
    private let geometryWidth: CGFloat
    public var tabs: [OlaTabRowItem<Content>]
    
    public class OlaTabRowSize: ObservableObject {
        @Published public var value: CGSize = .zero
    }
    
    public init(fixed: Bool = true,
                centerAnchor: Bool = false,
                isVertical: Bool = false,
                geometryWidth: CGFloat,
                selectedTabIndex: Binding<Int>,
                tabs: [OlaTabRowItem<Content>]) {
        self.fixed = fixed
        self.centerAnchor = centerAnchor
        self.isVertical = isVertical
        self.geometryWidth = geometryWidth
        self._selectedTabIndex = selectedTabIndex
        self.tabs = tabs
    }
    
    ///
    /// Computed property for horizontal Tab row
    ///
    var horizontalTabRow: some View {
          ScrollViewReader { scrollView in
             ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0 ..< tabs.count, id: \.self) { index in
                        tabs[index].animation(.default, value: selectedTabIndex == index)
                        .frame(width: fixed && !isTablet ? (geometry.bounds.size.width / CGFloat(tabs.count)) : .none)
                        .onTapGesture { tabs[index].onClick() }
                    }
                }
                .modifier(SizeModifier())
                .offset(x: CGFloat((fixed || !isTablet  ? 0.0 : ((geometry.bounds.size.width - self.size.value.width) / 2 < CGFloat(self.offset.value)) ? 80.0 : 0.0)))
                .padding(.trailing, CGFloat((fixed || !isTablet ? 0.0 : ((geometry.bounds.size.width - self.size.value.width) / 2 < CGFloat(self.offset.value)) ? 80.0 : 0.0)))
                .edgesIgnoringSafeArea(.trailing)
            }
            .onChange(of: selectedTabIndex) { index in
                withAnimation {
                    if centerAnchor {
                        scrollView.scrollTo(index, anchor: .center)
                    } else {
                        scrollView.scrollTo(index)
                    }
                }
            }
            .frame(alignment: .center)
            .onPreferenceChange(SizePreferenceKey.self) { value in
                guard value.width != 0 && value.height != 0 else { return }
                
                DispatchQueue.main.async {
                    self.size.value = value
                }
            }
        }
       .fixedSize(horizontal: ((geometry.bounds.size.width - self.size.value.width) / 2 > CGFloat(self.offset.value)  ? true : false), vertical: true)
       .frame(height: tabRowHeight, alignment: .center)
    }
    
    ///
    /// Computed property for vertical Tab row
    ///
    var verticalTabRow: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { scrollView in
                VStack {
                    ForEach(0 ..< tabs.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                tabs[index].onClick()
                            }
                        }, label: {
                            tabs[index]
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        })
                        .accentColor(Color.white)
                    }
                }
                .onChange(of: selectedTabIndex) { target in
                    withAnimation {
                        scrollView.scrollTo(target)
                    }
                }
                .padding(.leading, CGFloat(isTablet ? 6.0 : 16.0))
                .frame(height: UIScreen.main.bounds.height, alignment: /*isTablet ?.top :*/ .center)
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) { value in
                    guard value.width != 0 && value.height != 0 else { return }
                    Offset.set(value.width)
                }
            }
        }
        .fixedSize(horizontal: orientation.isLandscape ? true : false, vertical: false)
    }
    
    public var body: some View {
        if isVertical { verticalTabRow } else { horizontalTabRow }
    }
}

internal struct Tabs_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            OlaTabRow<Text>(
                    fixed: true,
                    isVertical: false,
                    geometryWidth: 375,
                    selectedTabIndex: .constant(0),
                    tabs: [
                        .init(onClick: { print("Click on Tab 1") }, content: { Text("Tab 1").foregroundColor(.black) }),
                        .init(onClick: { print("Click on Tab 2") }, content: { Text("Tab 2").foregroundColor(.black) }),
                        .init(onClick: { print("Click on Tab 3") }, content: { Text("Tab 3").foregroundColor(.black) })
                    ])
        }
        .fixedSize(horizontal: true, vertical: true)
        .previewDisplayName("Horizontal OlaTabRow")
        
        ZStack {
            OlaTabRow<Text>(
                    fixed: true,
                    isVertical: true,
                    geometryWidth: 375,
                    selectedTabIndex: .constant(0),
                    tabs: [
                        .init(onClick: { print("Click on Tab 1") }, content: { Text("Tab 1").foregroundColor(.black) }),
                        .init(onClick: { print("Click on Tab 2") }, content: { Text("Tab 2").foregroundColor(.black) }),
                        .init(onClick: { print("Click on Tab 3") }, content: { Text("Tab 3").foregroundColor(.black) })
                    ])
        }
        .fixedSize(horizontal: true, vertical: true)
        .previewDisplayName("Vertical OlaTabRow")
    }
}
