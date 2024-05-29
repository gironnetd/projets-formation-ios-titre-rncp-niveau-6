//
//  OlaBackground.swift
//  designsystem
//
//  Created by damien on 14/12/2022.
//

import SwiftUI
import common


public struct OlaBackgroundStyle: ViewModifier {
    
    @EnvironmentObject private var localGradientColors: GradientColors
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.geometry) private var geometry
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var orientation: Orientation = Orientation.shared
    
    private let topColor: Color
    private let bottomColor: Color
    private let containerColor: Color
    
    public init(topColor: Color = Color.clear,
                bottomColor: Color = Color.clear,
                containerColor: Color = Color.clear) {
        self.topColor = topColor
        self.bottomColor = bottomColor
        self.containerColor = containerColor
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            if topColor != Color.clear || bottomColor != Color.clear {
                LinearGradient(gradient:  Gradient(stops: [
                    .init(color: topColor, location: 0.0),
                    .init(color: bottomColor, location: 0.8)
                ]), startPoint: .top, endPoint: .bottom
                ).edgesIgnoringSafeArea([.top, .bottom])
            } else {
                LinearGradient(gradient:  Gradient(stops: [
                    .init(color: localGradientColors.top, location: 0.0),
                    .init(color: localGradientColors.bottom, location: 0.8)
                ]), startPoint: .top, endPoint: .bottom
                ).brightness(colorScheme == .light ? 0.0 : -0.02)
                    .edgesIgnoringSafeArea([.top, .bottom])
            }
            HStack {
                let flowersLeft = switch localColorScheme.themeBrand {
                case .primary:
                    OlaIcons.PrimaryFlowersLeft
                case .secondary:
                    OlaIcons.SecondaryFlowersLeft
                case .tertiary:
                    OlaIcons.TertiaryFlowersLeft
                case .quaternary:
                    OlaIcons.QuaternaryFlowersLeft
                }
                
                flowersLeft.resizable()
                .aspectRatio(
                    CGSize(
                        width: 200,
                        height: 321),
                    contentMode: .fit)
                .frame(width: (600.0 * 3 * 100 / 1290.0).adjustImage(),
                       alignment: .top)
                
                Spacer()
                
                let flowersRight = switch localColorScheme.themeBrand {
                case .primary:
                    OlaIcons.PrimaryFlowersRight
                case .secondary:
                    OlaIcons.SecondaryFlowersRight
                case .tertiary:
                    OlaIcons.TertiaryFlowersRight
                case .quaternary:
                    OlaIcons.QuaternaryFlowersRight
                }
                
                flowersRight.resizable()
                .aspectRatio(
                    CGSize(
                        width: 200,
                        height: 321),
                    contentMode: .fit)
                .frame(width: (600.0 * 3 * 100 / 1290.0).adjustImage(),
                       alignment: .top)
            }.edgesIgnoringSafeArea([.top, .horizontal])
            
            content
                .frame(width: UIScreen.main.bounds.width + 16)
                .edgesIgnoringSafeArea(.vertical)
                .onRotate { newOrientation in
                    guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                    if newOrientation.isValidInterfaceOrientation {
                        if newOrientation == .portraitUpsideDown {
                            if #unavailable(iOS 16) {
                                if scene.interfaceOrientation.rawValue != self.orientation.current.rawValue {
                                    self.orientation.current = scene.interfaceOrientation.isPortrait ? (UIDeviceOrientation.portrait) : UIDeviceOrientation.landscapeLeft
                                }
                            } else if isTablet {
                                if scene.interfaceOrientation.rawValue != self.orientation.current.rawValue {
                                    self.orientation.current = scene.interfaceOrientation.isPortrait ? (UIDeviceOrientation.portrait) : UIDeviceOrientation.landscapeLeft
                                }
                            }
                        } else {
                            if scene.interfaceOrientation.rawValue != self.orientation.current.rawValue {
                                self.orientation.current = scene.interfaceOrientation.isPortrait ? (UIDeviceOrientation.portrait) : UIDeviceOrientation.landscapeLeft
                            }
                        }
                    }
                }
                .environmentObject(orientation)
        }
    }
}

public extension View {
    func OlaBackground() -> some View {
        modifier(OlaBackgroundStyle())
    }
}

internal struct OlaBackground_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { _ in
            OlaTheme(darkTheme: .systemDefault) {
                OlaIcons.DoveIcon.resizable()
                    .padding(.bottom, 30)
                    .frame(
                        minWidth: UIScreen.main.bounds.width,
                        minHeight: UIScreen.main.bounds.height ,
                        alignment: .top)
                    .environmentObject(GradientColors())
                    .OlaBackground()
            }
        }.preferredColorScheme(.light)
    }
}
