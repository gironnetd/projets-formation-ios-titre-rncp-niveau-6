//
//  BiographyCard.swift
//  ui
//
//  Created by Damien Gironnet on 09/08/2023.
//

import SwiftUI
import model
import designsystem
import common
import domain

public struct BiographyCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    @ObservedObject private var offset: Offset = Offset.shared
    
    @ObservedObject private var biography: UserBiography
    private let onToggleBookmark: (UserResource) -> Void
    
    public init(biography: UserBiography,
                onToggleBookmark: @escaping (UserResource) -> Void) {
        self.biography = biography
        self.onToggleBookmark = onToggleBookmark
    }
    
    @ViewBuilder
    public var body: some View {
        VStack {
            ForEach(0..<5, id:\.self) { index in
                if index == 0 {
                    if let presentation0 = biography.presentation {
                        HStack(alignment: .top) {
                            CardTitle(title: "Introduction")
                            
                            Spacer()
                            
                            BookmarkButton(isBookmarked: biography.isSaved,
                                           onClick: { onToggleBookmark(biography) })
                                .padding(.trailing, isTablet ? 0.0 : 4.0)
                                .padding(.top, CGFloat(6).adjustPadding())
                                .frame(alignment: .trailing)
                        }.padding(.bottom, 20)
                        
                        CardTextContent(
                            text: presentation0,
                            width: (isTablet ?
                                       ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 32.0)) :
                                        (orientation.isPortrait ?
                                         (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                                            (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2)))
                            - CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding() * 2)
                            .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                                     CGFloat(isTablet ?20.0 : 10.0).adjustHorizontalPadding() :
                                        CGFloat(isTablet ? 20.0 : 10.0).adjustHorizontalPadding())
                    }
                }
                
                if index == 1 {
                    if let presentation1 = biography.presentation1 {
                        presentation(presentationTitle: biography.presentationTitle1, presentation: presentation1)
                            .padding(.bottom, 10)
                    }
                }
                
                if index == 2 {
                    if let presentation2 = biography.presentation2 {
                        presentation(presentationTitle: biography.presentationTitle2, presentation: presentation2)
                            .padding(.bottom, 10)
                    }
                }
                
                if index == 3 {
                    if let presentation3 = biography.presentation3 {
                        presentation(presentationTitle: biography.presentationTitle3, presentation: presentation3)
                            .padding(.bottom, 10)
                    }
                }
                
                if index == 4 {
                    if let presentation4 = biography.presentation4 {
                        presentation(presentationTitle: biography.presentationTitle4, presentation: presentation4)
                            .padding(.bottom, 10)
                    }
                }
            }
        }
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding())
        .Card()
        .frame(width: isTablet ?
               ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 32.0)) :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2)))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
    
    @ViewBuilder
    func presentation(presentationTitle: String?, presentation: String) -> some View {
        VStack(alignment: .leading) {
            if let presentationTitle = presentationTitle {
                CardTitle(title: presentationTitle).padding(.bottom, 20)
            }
            
            CardTextContent(
                text: presentation,
                width: (isTablet ?
                           ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 32.0)) :
                            (orientation.isPortrait ?
                             (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                                (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2)))
                - CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding() * 2)
                .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                         CGFloat(isTablet ?20.0 : 10.0).adjustHorizontalPadding() :
                            CGFloat(isTablet ? 20.0 : 10.0).adjustHorizontalPadding())
        }

    }
}
