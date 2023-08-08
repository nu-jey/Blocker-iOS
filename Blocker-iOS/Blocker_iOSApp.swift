//
//  Blocker_iOSApp.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/06/30.
//

import SwiftUI
import GoogleSignIn

@main
struct Blocker_iOSApp: App {
    @StateObject var laucnViewModel = LaunchViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(laucnViewModel)
        }
    }
}
