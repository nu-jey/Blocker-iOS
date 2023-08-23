//
//  ContentView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/06/30.
//

import SwiftUI
import GoogleSignInSwift

struct LaunchView: View {
    @State var modalControl: Bool = false
    @State var emailAddress: String = ""
    @State var password: String = ""
    let logoSize = UIScreen.main.bounds.width * 0.5
    @StateObject var launchViewModel:LaunchViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Image("blocker")
                    .resizable()
                    .frame(width: logoSize, height: logoSize)
                VStack{
                    Divider()
                    GoogleSignInButton {
                        launchViewModel.googleLogin()
                    }
                    .fullScreenCover(isPresented: $launchViewModel.isLogined) {
                        ContentView()
                    }
                }
            }
            .padding()
            .background(Color("backgroundColor"))
        }
        .alert(LocalizedStringKey("로그인 실패"), isPresented: $launchViewModel.isAlert) {
                    Text("확인")
                } message: {
                    Text("다시 시도해주세요")
                }
    }
        
}

//struct SignUpView: View {
//    @Environment(\.presentationMode) var presentation
//    @State var signUpAlertControl: Bool = false
//    @Environment(\.dismiss) private var dismiss
//    @StateObject var launchViewModel:LaunchViewModel
//    var signView = SignView()
//    var body: some View {
//        VStack {
//            signView
//            Divider()
//            Button("Sign Up", action: {
//                // 구글 계정 + 작성된 전자서명으로 회원 가입 진행 
//            })
//            .alert("회원가입", isPresented: $signUpAlertControl) {
//                Button {
//                    dismiss()
//                } label: {
//                    Text("OK")
//                }
//            } message: {
//                Text("회원가입이 완료되었습니다.")
//            }
//        }
//        .padding()
//    }
//}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(launchViewModel: LaunchViewModel())
    }
}
