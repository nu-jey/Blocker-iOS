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
    
    @Published var user: Firebase.User?
    
    init() {
        user = Auth.auth().currentUser
    }
    
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
        }
        
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            self.user = result?.user
        }
    }
    
    func signOut() {
        user = nil
        try? Auth.auth().signOut()
    }
    
}
