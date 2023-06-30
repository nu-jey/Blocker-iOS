//
//  AuthModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/06/30.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthModel: ObservableObject {
    init() {}
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
        }
        
    }
}
