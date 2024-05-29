//
//  SceneDelegate.swift
//  mobile
//
//  Created by damien on 25/11/2022.
//

import UIKit
import SwiftUI
import FacebookCore
import Firebase
import common
import designsystem
import Factory
import remote
import navigation
import authentication
import main
import ui
import content
import data
import model
import work
import preferences

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    internal var window: UIWindow?
    
    @LazyInjected(\.mainRouter) var mainRouter
    @LazyInjected(\.olaPreferences) var olaPreferences
    @Injected(\.networkMonitor) var networkMonitor
        
    private lazy var mainApplication: some View = {
        OlaTheme(darkTheme: olaPreferences.userData.value.darkThemeConfig,
                 themeBrand: olaPreferences.userData.value.themeBrand) { [self] in
            OlaApplication()
                .environmentObject(Orientation.shared).OlaBackground()
        }.environmentObject(mainRouter)
    }()
        
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
        
        for urlContext in URLContexts {
            let url = urlContext.url
            Auth.auth().canHandle(url)
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
        Container.shared.mainViewController.register { AppleSignInViewController(rootView: self.mainApplication) }

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = Container.shared.mainViewController.callAsFunction()
            
            switch olaPreferences.userData.value.darkThemeConfig {
            case .systemDefault:
                window.rootViewController?.view.overrideUserInterfaceStyle = .unspecified
            case .light:
                window.rootViewController?.view.overrideUserInterfaceStyle = .light
            case .dark:
                window.rootViewController?.view.overrideUserInterfaceStyle = .dark
            }
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
}
