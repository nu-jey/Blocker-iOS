//
//  Blocker_iOSApp.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/06/30.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Blocker_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authModel: AuthModel = AuthModel()
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(authModel)
        }
    }
}
