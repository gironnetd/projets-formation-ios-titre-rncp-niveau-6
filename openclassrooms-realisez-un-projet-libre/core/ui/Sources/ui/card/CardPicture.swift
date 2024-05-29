//
//  CardPicture.swift
//  ui
//
//  Created by Damien Gironnet on 25/04/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

///
/// Structure representing card picture
///
public struct CardPicture: View {
    
    private let picture: Data?
    
    public init(picture: Data?) {
        self.picture = picture
    }
    
    public var body: some View {
        if let picture = picture, let uiImage = UIImage(data: picture) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(CGSize(width: uiImage.size.width, height: uiImage.size.height), contentMode: .fit)
                .frame(maxWidth: .infinity, alignment: .top)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct CardPicture_Previews: PreviewProvider {
    static var previews: some View {
        CardPicture(picture:  UserPicturesPreviewParameterProvider.pictures[0].picture!)
    }
}
