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
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
