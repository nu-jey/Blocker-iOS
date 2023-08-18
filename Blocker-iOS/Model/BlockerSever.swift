//
//  BlockerSever.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/18.
//

import Foundation

struct BlockerServer {
    private var refreshToken:String = ""
    private var accessToken:String = ""
    private let host:String = ""
    static let shared = BlockerServer()
    
    mutating func setToken(_ refreshToken: String?, _ accessToken: String?) {
        if refreshToken != nil {
            self.refreshToken = refreshToken!
        }
        if accessToken != nil {
            self.accessToken = accessToken!
        }
    }
    func printToken() {
        print("123")
        print(self.refreshToken)
        print(self.accessToken)
    }
    func login(_ user: UserData) {
        // 구글 로그인 통해서 얻은 profile 정보로 로그인 시도
        var request = URLRequest(url: URL(string: "\(self.host)/users/login")!)
        request.httpMethod = "Post"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // body
        let body = [
            "email": "\(user.email)",
            "name": "\(user.name)",
            "picture": "\(user.url!)"
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        URLSession(configuration: .default).dataTask(with: request) {(data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            print(response)
            // response의 상태코드 따라 분기 처리
            // 200 -> 로그인
            // self.isLogined = true
            // self.state = .signedIn
            
            // 201 -> 전자 서명 작성 뷰로 이동
            // 전자 서명 작성 후 전자 서명 등록 API 호출해서 회원가입 진행
            
            
        }.resume()
        
    }
}
