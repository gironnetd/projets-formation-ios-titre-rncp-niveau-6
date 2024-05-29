//
//  VerticalStaggeredGrid.swift
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

public class Columns<Content: View>: ObservableObject {
    var columns: [Column<Content>] = []
    
    public let numberOfColumns: Int
    
    public init(columns: [ColumnElement<Content>], numberOfColumns: Int = 2) {
        self.numberOfColumns = numberOfColumns
        
        for _ in 0..<numberOfColumns {
            self.columns.append(Column())
        }
        
        for (index, column) in columns.enumerated() {
            self.columns[index % numberOfColumns].elements.append(column)
        }
    }
}

public struct Column<Content: View>: Identifiable {
    public var id: String { uid }
    
    public let uid: String
    public var elements: [ColumnElement<Content>] = []
    
    public init() {
        self.uid = UUID().uuidString
    }
}

public struct ColumnElement<Content: View>: Identifiable {
    public var id: String { uid }
    
    public let uid: String
    internal var content: Content
    var size: (value: CGSize, computedVersion: Int)
    
    public init(uid: String, content: Content, size: CGSize = .zero) {
        self.uid = uid
        self.content = content
        self.size = (size, 1)
    }
}

public class ElementsSize: ObservableObject {
    @Published var elements: [Element] = []
}

public struct Element {
    public let uid: String
    public var size: CGSize
    public var computedVersion: Int
    
    public init(uid: String, size: CGSize, computedVersion: Int = 0) {
        self.uid = uid
        self.size = size
        self.computedVersion = computedVersion
    }
}

public struct VerticalStaggeredGrid<Data: Collection, Content: View>: View where Data.Element: Hashable {
    
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var elementsSize: ElementsSize
    private var columns: Columns<Content>
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    @State private var allElementsComputed: Bool = false
    
    private let computationTimes: Int
    
    public init(columns: Columns<Content>, computationTimes: Int = 1) {
        self.columns = columns
        self.elementsSize = ElementsSize()
        self.computationTimes = computationTimes
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: isTablet ? 22 : 16) {
            ForEach(computeColumns()) { column in
                VStack(alignment: .leading, spacing: isTablet ? 0 : 0) {
                    ForEach(column.elements) { element in
                        element.content.fixedSize(horizontal: true, vertical: true).opacity(allElementsComputed ? 1 : 0)
                            .animation(nil)
                            .readSize { value in
                                DispatchQueue.main.async {
                                    if columns.columns.flatMap({ $0.elements }).count != elementsSize.elements.count {
                                        elementsSize.elements.append(Element(uid: element.uid, size: value, computedVersion: 0))
                                    }
                                }
                            }
                    }
                }
            }
        }
        .opacity(allElementsComputed ? 1 : 0)
        .onRotate(perform: { newOrientation in
            if newOrientation.isValidInterfaceOrientation &&
                newOrientation != .faceUp && newOrientation != .faceDown &&
                newOrientation != orientation {
                DispatchQueue.main.async {
                    allElementsComputed = false
                    elementsSize.elements.removeAll()
                }
            }
        })
    }
    
    func computeColumns() -> [Column<Content>] {
        guard columns.columns.flatMap({ $0.elements }).count == elementsSize.elements.count && elementsSize.elements.count > 2  else {
            if elementsSize.elements.count <= 2 {
                DispatchQueue.main.async {
                    withAnimation {
                        if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                        allElementsComputed = true
                    }
                }
            }
            
            return columns.columns
        }
        
        var tmp = columns.columns
        var tmpElements: [Element] = []
        
        while tmp.flatMap({ $0.elements }).isNotEmpty {
            for index in 0..<columns.numberOfColumns {
                if tmp[index].elements.isNotEmpty {
                    if let elementIndex = elementsSize.elements.firstIndex(where: { $0.uid == tmp[index].elements[0].uid }) {
                        tmpElements.append(elementsSize.elements.first(where: { $0.uid == tmp[index].elements[0].uid })!)
                        tmp[index].elements.remove(at: 0)
                    }
                }
            }
        }
        
        var tmpColumns: [[ColumnElement<Content>]] = Array(repeating: [ColumnElement<Content>](), count: columns.numberOfColumns)
        
        for _ in 0..<computationTimes {
            for i in tmpElements {
                tmpColumns.sort(by: { $0.map({ $0.size.value.height }).reduce(0, +) < $1.map({ $0.size.value.height }).reduce(0, +) })
                
                if var element = columns.columns.flatMap({ $0.elements }).first(where: { $0.uid == i.uid }),
                   let index = tmpColumns.firstIndex(where: { $0.contains(where: { $0.uid == element.uid }) }),
                   let elementIndex = tmpColumns[index].firstIndex(where: { $0.uid == element.uid }) {
                    if tmpColumns[index].count != 1 && tmpColumns[index][elementIndex].size.value != element.size.value {
                        element.size.value = i.size
                        element.size.computedVersion += 1
                        tmpColumns[0].append(element)
                        tmpColumns[index].remove(at: elementIndex)
                    }
                } else if var element = columns.columns.flatMap({ $0.elements }).first(where: { $0.uid == i.uid }) {
                    element.size = (value: i.size, computedVersion: 0)
                    tmpColumns[0].append(element)
                }
            }
        }
        
        let biggestTmpColumns = tmpColumns.sorted(by: {
            $0.map({ $0.size.value.height}).reduce(0, +) > $1.map({ $0.size.value.height}).reduce(0, +) })[0].map({ $0.size.value.height }).reduce(0, +)
        
        let biggestColumns: CGFloat = columns.columns[0].elements.map({ $0.size.value.height }).reduce(0, +)
        
        if biggestTmpColumns < biggestColumns || biggestColumns == .zero {
            tmpColumns
                .sorted(by: { $0.map({ $0.size.value.height }).reduce(0, +) > $1.map({ $0.size.value.height }).reduce(0, +) })
                .enumerated().forEach { index, elements in
                    columns.columns[index].elements = elements
                }
            
            DispatchQueue.main.async {
                withAnimation {
                    if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                    allElementsComputed = true
                }
            }
        }
        
        return columns.columns
    }
}
