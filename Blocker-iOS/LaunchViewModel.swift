//
//  LaunchViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/22.
//

import Foundation
import GoogleSignInSwift
import GoogleSignIn

class LaunchViewModel: ObservableObject {
    // 로그인 상태
    enum SignInState {
      case signedIn
      case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    @Published var isLogined = false
    @Published var userData:UserData = UserData(url: nil, name: "", email: "")
    @Published var isAlert = false
    @Published var isSignUp = false
    private var idToken:String = ""
    
    func checkState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // 로그아웃 상태
                print("Not Sign In")
            } else {
                // 로그인 상태
                guard let profile = user?.profile else { return }
                let data = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
                self.userData = data
                self.isLogined = true
            }
        }
    }
    
    func googleLogin() {
        // rootViewController
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        // 로그인 진행
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let result = signInResult else {
                self.isAlert = true
                return
            }
            guard let profile = result.user.profile else { return }
            let data = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
            self.userData = data
            self.idToken = result.user.idToken!.tokenString
            BlockerServer.shared.login(self.userData)
        }
    }
    
    func googleSignUp() {
        // rootViewController
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        // 구글 계정으로 회원가입하기 위해서 구글 로그인 진행
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let result = signInResult else {
                self.isAlert = true
                return
            }
            guard let profile = result.user.profile else { return }
            let data = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
            self.userData = data
            self.idToken = result.user.idToken!.tokenString
            self.isSignUp = true // 전자 서명 작성을 위해
        }
    }
    func signOut() {
        self.state = .signedOut
    }
    
    func refresh() {
        var request = URLRequest(url: URL(string: "http://13.209.237.234/users/reissue-token")!)
        request.httpMethod = "Get"
        // header -> ㄱefreshToken 값만 보내는 걸로(세미콜론 빼고)
        request.setValue("refreshToken=eyJhbGciOiJIUzI1NiJ9.eyJ2YWx1ZSI6IjJlZDQ2NmJmNDRiMzQ0MDQ5Y2JlZWYxYzA3Njk4OThmIiwiaWF0IjoxNjkyMzM1Nzc5LCJleHAiOjE2OTM1NDUzNzl9.a_054Dtg1AIJAuDKEnjCkBQVNC6c5OeYRNHlvM1xw_I", forHTTPHeaderField: "Cookie")
        
        // API 호출 -> 반환값에 따른 분기 처리
        let approvalTask = URLSession(configuration: .default).dataTask(with: request) {(data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            print(response)
        }
        approvalTask.resume()
    }
}
