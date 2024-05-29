//
//  FlexibleGrid.swift
//  ui
//
//  Created by Damien Gironnet on 24/04/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

public extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: FlexibleGridSizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(FlexibleGridSizePreferenceKey.self, perform: onChange)
    }
}

public struct FlexibleGridSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

///
/// Structure representing flexible grid
///
public struct FlexibleGrid<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows, id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }
    
    var computeRows: [[Data.Element]] {
        var rows: [(elements: [Data.Element], remainingWidth: CGFloat)] = []
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            
            rows.append((elements: [element], remainingWidth: availableWidth  - (elementSize.width + spacing)))
        }
        
        rows.sort(by: { $0.remainingWidth < $1.remainingWidth })
        
        for _ in rows {
            var iterator = rows.filter({ $0.elements.isNotEmpty }).makeIterator()

            while let row = iterator.next() {
                var elements = data.map { element in element }.filter({ element in !row.elements.contains(element) })
                    .map({ r in elementsSize[r , default: CGSize(width: availableWidth, height: 1)] })
                    .filter({ element in row.remainingWidth - (element.width) >= 0 })
                    
                elements.sort(by: { $0.width > $1.width })
                
                for newElement in elements {
                    if let appendIndex = rows.firstIndex(where: { element in element == row}),
                       let removeIndex = rows.firstIndex(where: { row in row.elements.contains(elementsSize.first(where: { $1 == newElement })!.key)}) {

                        if appendIndex < removeIndex {
                            rows[appendIndex]
                                .elements.append(elementsSize.first(where: { $1 == newElement })!.key)
    
                            rows[appendIndex].remainingWidth -= (newElement.width)
    
                            rows[removeIndex].elements.remove(at: rows[removeIndex].elements.firstIndex(of: elementsSize.first(where: { $1 == newElement })!.key)!)
                        }
                    }
                }
            }
            
            rows.sort(by: { $0.remainingWidth < $1.remainingWidth })
            
            while let row = iterator.next() {
                var elements = data.map { element in element }.filter({ element in !row.elements.contains(element) })
                    .map({ r in elementsSize[r , default: CGSize(width: availableWidth, height: 1)] })
                    .filter({ element in row.remainingWidth - (element.width) >= 0 })
                    
                elements.sort(by: { $0.width > $1.width })
                
                for newElement in elements {
                    if let appendIndex = rows.firstIndex(where: { element in element == row}),
                       let removeIndex = rows.firstIndex(where: { row in row.elements.contains(elementsSize.first(where: { $1 == newElement })!.key)}) {

                        if appendIndex < removeIndex {
                            rows[appendIndex]
                                .elements.append(elementsSize.first(where: { $1 == newElement })!.key)
    
                            rows[appendIndex].remainingWidth -= (newElement.width)
    
                            rows[removeIndex].elements.remove(at: rows[removeIndex].elements.firstIndex(of: elementsSize.first(where: { $1 == newElement })!.key)!)
                        }
                    }
                }
            }
            
            rows.sort(by: { $0.remainingWidth < $1.remainingWidth })
           
            while let row = iterator.next() {
                var elements = data.map { element in element }.filter({ element in !row.elements.contains(element) })
                    .map({ r in elementsSize[r , default: CGSize(width: availableWidth, height: 1)] })
                    .filter({ element in row.remainingWidth - (element.width) >= 0 })
                    
                elements.sort(by: { $0.width > $1.width })
                
                for newElement in elements {
                    if let appendIndex = rows.firstIndex(where: { element in element == row}),
                       let removeIndex = rows.firstIndex(where: { row in row.elements.contains(elementsSize.first(where: { $1 == newElement })!.key)}) {

                        if appendIndex < removeIndex {
                            rows[appendIndex]
                                .elements.append(elementsSize.first(where: { $1 == newElement })!.key)
    
                            rows[appendIndex].remainingWidth -= (newElement.width)
    
                            rows[removeIndex].elements.remove(at: rows[removeIndex].elements.firstIndex(of: elementsSize.first(where: { $1 == newElement })!.key)!)
                        }
                    }
                }
            }
            
            rows.sort(by: { $0.remainingWidth < $1.remainingWidth })

            while let row = iterator.next() {
                var elements = data.map { element in element }.filter({ element in !row.elements.contains(element) })
                    .map({ r in elementsSize[r , default: CGSize(width: availableWidth, height: 1)] })
                    .filter({ element in row.remainingWidth - (element.width) >= 0 })
                    
                elements.sort(by: { $0.width > $1.width })
                
                for newElement in elements {
                    if let appendIndex = rows.firstIndex(where: { element in element == row}),
                       let removeIndex = rows.firstIndex(where: { row in row.elements.contains(elementsSize.first(where: { $1 == newElement })!.key)}) {

                        if appendIndex < removeIndex {
                            rows[appendIndex]
                                .elements.append(elementsSize.first(where: { $1 == newElement })!.key)
    
                            rows[appendIndex].remainingWidth -= (newElement.width)
    
                            rows[removeIndex].elements.remove(at: rows[removeIndex].elements.firstIndex(of: elementsSize.first(where: { $1 == newElement })!.key)!)
                        }
                    }
                }
            }
            
            rows.sort(by: { $0.remainingWidth < $1.remainingWidth })

            while let row = iterator.next() {
                var elements = data.map { element in element }.filter({ element in !row.elements.contains(element) })
                    .map({ r in elementsSize[r , default: CGSize(width: availableWidth, height: 1)] })
                    .filter({ element in row.remainingWidth - (element.width) >= 0 })
                    
                elements.sort(by: { $0.width > $1.width })
                
                for newElement in elements {
                    if let appendIndex = rows.firstIndex(where: { element in element == row}),
                       let removeIndex = rows.firstIndex(where: { row in row.elements.contains(elementsSize.first(where: { $1 == newElement })!.key)}) {

                        if appendIndex < removeIndex {
                            rows[appendIndex]
                                .elements.append(elementsSize.first(where: { $1 == newElement })!.key)
    
                            rows[appendIndex].remainingWidth -= (newElement.width)
    
                            rows[removeIndex].elements.remove(at: rows[removeIndex].elements.firstIndex(of: elementsSize.first(where: { $1 == newElement })!.key)!)
                        }
                    }
                }
            }
            
            rows.sort(by: { $0.remainingWidth < $1.remainingWidth })

            while let row = iterator.next() {
                var elements = data.map { element in element }.filter({ element in !row.elements.contains(element) })
                    .map({ r in elementsSize[r , default: CGSize(width: availableWidth, height: 1)] })
                    .filter({ element in row.remainingWidth - (element.width) >= 0 })
                    
                elements.sort(by: { $0.width > $1.width })
                
                for newElement in elements {
                    if let appendIndex = rows.firstIndex(where: { element in element == row}),
                       let removeIndex = rows.firstIndex(where: { row in row.elements.contains(elementsSize.first(where: { $1 == newElement })!.key)}) {

                        if appendIndex < removeIndex {
                            rows[appendIndex]
                                .elements.append(elementsSize.first(where: { $1 == newElement })!.key)
    
                            rows[appendIndex].remainingWidth -= (newElement.width)
    
                            rows[removeIndex].elements.remove(at: rows[removeIndex].elements.firstIndex(of: elementsSize.first(where: { $1 == newElement })!.key)!)
                        }
                    }
                }
            }
        }
        
        return rows.filter({ row in row.elements.isNotEmpty }).map({ $0.elements })
    }
}
