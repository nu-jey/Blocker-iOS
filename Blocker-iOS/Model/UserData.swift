//
//  UserData.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/22.
//

import Foundation
class UserData {
    var name:String
    var email:String
    var url:URL?
    
    init(url: URL?, name: String, email: String) {
        self.url = url
        self.name = name
        self.email = email
    }
    
    func getSignature() {
        
    }
    
    func editSignature() {
        
    }
    
    func addFavorites() {
        
    }
    
    func deleteFavorites() {
        
    }
    
    func searchMyPost() {
        
    }
}
