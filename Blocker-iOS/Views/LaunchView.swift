//
//  ContentView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/06/30.
//

import SwiftUI

struct LaunchView: View {
    @State var mainViewControl: Bool = false
    @State var modalControl: Bool = false
    @State var emailAddress: String = ""
    @State var password: String = ""
    @EnvironmentObject var authModel: AuthModel
    let logoSize = UIScreen.main.bounds.width * 0.5
    var body: some View {
        VStack {
            Image("blocker")
                .resizable()
                .frame(width: logoSize, height: logoSize)
            VStack{
                TextField("Enter your email", text: $emailAddress)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(5)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(5)
                
                Button(action: {
                    authModel.signIn(email: emailAddress, password: password)
                    if authModel.user != nil {
                        mainViewControl = true
                    } else {
                        // 로그인 실패 경우
                        
                    }
                }) {
                    Text("Sign In")
                        .tint(Color("textColor"))
                }
                .padding()
                .fullScreenCover(isPresented: $mainViewControl) {
                    ContentView()
                }
                Divider()
                
                Button(action: {
                    print("회원가입")
                    modalControl = true
                }) {
                    Text("Sign Up")
                        .tint(Color("textColor"))
                }
                .padding()
                .sheet(isPresented: $modalControl) {
                    SignUpView()
                }
            }
        }
        .padding()
        .background(Color("backgroundColor"))
    }
}

struct SignUpView: View {
    @Environment(\.presentationMode) var presentation
    @State var emailAddress: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    @State var validEmail: Bool = false
    @State var validPassWord: Bool = false
    @State var signUpAlertControl: Bool = false
    @EnvironmentObject var authModel: AuthModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Email")
                TextField("Enter your email", text: $emailAddress)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(5)
                    .border(.red, width: isValidEmail(testStr: emailAddress) ? 0: 1)
                
                Text("Password")
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(5)
                    .border(.red, width: password.count >= 6 ? 0 : 1)
                
                Text("Password Check")
                SecureField("Password", text: $passwordConfirm)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(5)
                    .border(.red, width: (password != passwordConfirm)||(password == "") ? 1 : 0)
            }
            Divider()
            Button("Sign Up", action: {
                if isValidEmail(testStr: emailAddress) {
                    validEmail = true
                }
                if password.count >= 6 && password == passwordConfirm {
                    validPassWord = true
                }
                if validEmail, validPassWord {
                    signUpAlertControl = true
                    authModel.signUp(email: emailAddress, password: password)
                }
            })
            .alert("회원가입", isPresented: $signUpAlertControl) {
                Button {
                    dismiss()
                } label: {
                    Text("OK")
                }
            } message: {
                Text("회원가입이 완료되었습니다.")
            }
            
        }
        .padding()
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: testStr)
    }
    
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
