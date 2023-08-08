//
//  UserData.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/22.
//

import Foundation
struct UserData {
    let url:URL?
    let name:String
    let email:String
    
    init(url: URL?, name: String, email: String) {
        self.url = url
        self.name = name
        self.email = email
    }
}
