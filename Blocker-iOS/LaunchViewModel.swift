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
        }
        
        // 로그인 API 호출 -> IdToken 이용
        
        // API 호출 -> 반환값에 따른 분기 처리
        // 200 -> 로그인
        // 201 -> 전자 서명 작성 뷰로 이동
        
        // self.isLogined = true
        self.state = .signedIn
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
}
