//
//  tekaraApp.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 15/07/26.
//

import SwiftUI
import CoreText
#if DEBUG
import DebugSwift
#endif

@main
struct tekaraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    #if DEBUG
    private let debugSwift = DebugSwift()
    #endif

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        registerCustomFonts()
        #if DEBUG
        debugSwift.setup()
        // debugSwift.show()
        #endif
        return true
    }

    private func registerCustomFonts() {
        guard let fontURL = Bundle.main.url(forResource: "Baloo2-VariableFont_wght", withExtension: "ttf") else {
            print("[Font] Baloo2-VariableFont_wght.ttf not found in bundle")
            return
        }
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            if let cfError = error?.takeRetainedValue() {
                print("[Font] Failed to register Baloo 2: \(cfError)")
            }
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .landscape
    }
}
