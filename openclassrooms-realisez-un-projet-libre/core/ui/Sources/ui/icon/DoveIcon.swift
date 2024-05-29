//
//  DoveIcon.swift
//  ui
//
//  Created by Damien Gironnet on 24/05/2023.
//

import Foundation
import SwiftUI
import designsystem
import common

///
/// Variable representing dove icon for application
///
public var dove: some View {
    OlaIcons.DoveIcon
        .resizable()
        .aspectRatio(
            CGSize(width: 129, height: 145),
            contentMode: .fit)
        .frame(
            width: ((UIScreen.inches > 4.7 ? 691 : 587) * 3 * 100 / 1290.0).adjustImage(),
            height: ((UIScreen.inches > 4.7 ? 691 : 587) * 3 * 100 / 1290.0).adjustImage(),
            alignment: .center)
        .fixedSize(horizontal: true, vertical: true)
}
