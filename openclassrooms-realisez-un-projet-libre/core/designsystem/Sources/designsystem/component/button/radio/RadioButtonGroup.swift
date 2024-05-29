//
//  RadioButtonGroup.swift
//  designsystem
//
//  Created by Damien Gironnet on 09/10/2023.
//

import SwiftUI

public struct RadioButtonGroup: View {
    let orientation: Orientation
    let radioButtons: [RadioButton]
    
    public init(orientation: Orientation,
                radioButtons: [RadioButton]) {
        self.orientation = orientation
        self.radioButtons = radioButtons
    }
    
    public var body: some View {
        if orientation == .horizonal {
            HStack(alignment: .top) {
                ForEach(radioButtons.indices, id: \.self) { index in
                    radioButtons[index].padding(.trailing, 20)
                }
            }
        } else {
            VStack(alignment: .leading) {
                ForEach(radioButtons.indices, id: \.self) { index in
                    radioButtons[index].padding(.bottom, 10)
                }
            }
        }
    }
    
    public enum Orientation {
        case horizonal, vertical
    }
}
