//
//  PictureCard.swift
//  ui
//
//  Created by Damien Gironnet on 09/08/2023.
//

import SwiftUI
import model
import designsystem
import common
import domain

public struct PictureCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared

    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme

    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var picture: UserPicture
    
    private let onToggleBookmark: (UserResource) -> Void
    
    public init(picture: UserPicture,
                onToggleBookmark: @escaping (UserResource) -> Void) {
        self.picture = picture
        self.onToggleBookmark = onToggleBookmark
    }
    
    public var body: some View {
        let width = (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 3 - (24.0 * 2) / 2

        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let language = picture.followableTopics.first?.topic.language,
                       let comment = picture.comments?[language] {
                        Text(comment)
                            .foregroundColor(colorScheme == .light ? localColorScheme.Primary30 : localColorScheme.Primary10)
                            .textStyle(TypographyTokens.BodyLarge)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(8)
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 16)
                    }
                }
                
                Spacer()
                
                BookmarkButton(
                    lightColor: localColorScheme.primary,
                    darkColor: localColorScheme.primary,
                    isBookmarked: picture.isSaved,
                    onClick: { onToggleBookmark(picture) })
                .padding(.top, 2.0)
            }
            .padding(.bottom, 20)
            
            if let image = picture.picture {
                CardPicture(picture: image)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                             CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding() :
                                CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding())
            } else {
                RoundedRectangle(cornerRadius: 8).foregroundColor(Color.gray).opacity(0.1)
                    .aspectRatio(CGSize(width: picture.width, height: picture.height), contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                             CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding() :
                                CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding())
            }
        }
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding())
        .Card()
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width)
                :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

internal struct PictureCard_Previews: PreviewProvider {
    static var previews: some View {
        PictureCard(picture: UserPicturesPreviewParameterProvider.pictures[0],
                    onToggleBookmark: { _ in })
    }
}
