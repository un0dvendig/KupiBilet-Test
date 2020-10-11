//
//  AppDelegate.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import UIKit
import SwinjectAutoregistration

// MARK: - UIResponder
@main
class AppDelegate: UIResponder {
    // MARK: Properties
    let assembler: AppAssembler
    var window: UIWindow?
    
    // MARK: Initialization
    override init() {
        let assembler = AppAssembler(
            parent: nil
        )
        self.assembler = assembler
        super.init()
    }
    
    // MARK: Private methods
    private func createWindow() {
        let window = UIWindow(
            frame: UIScreen.main.bounds
        )
        let classifiersId: Int = 4
        let listingViewController = self.assembler.resolver ~> (
            ListingViewController.self,
            argument: classifiersId
        )
        window.rootViewController = listingViewController
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.createWindow()
        return true
    }
}
