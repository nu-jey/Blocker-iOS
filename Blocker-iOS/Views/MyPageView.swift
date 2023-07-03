//
//  MyPageView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/02.
//

import SwiftUI

struct MyPageView: View {
    @Binding var sideMenuControl: Bool
    var body: some View {
        ZStack {
            VStack {
                ProfileView()
            }
        }
    }
}
struct ProfileView: View {
    @State var signViewModalControl: Bool = false
    var body: some View {
        VStack {
            VStack {
                ProfileHeaderView()
                ProfileFooterView()
            }
            Spacer()
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Board")
                    Spacer()
                }
                HStack {
                    Text("Contracts")
                    Spacer()
                }
                HStack {
                    Text("Electronioc Signature")
                    Spacer()
                }
                Button(action: {signViewModalControl = true} ) {
                    Text("Sign")
                }
                    .sheet(isPresented: $signViewModalControl) {
                        SignView()
                    }
            }
            .padding()
            Divider()
            
        }
        
    }
    
}
struct ProfileHeaderView: View {
    let width = UIScreen.main.bounds.width / 2
    var body: some View {
            ZStack(alignment: .top){
                Rectangle()
                    .foregroundColor(Color("subBackgroundColor"))
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: width/2)
                Image(systemName: "person")
                    .resizable()
                    .padding()
                    .background(Color.gray)
                    .scaledToFit()
                    .clipShape(Circle().inset(by: 5))
                    .frame(width: width)
            }
    }
}
struct ProfileFooterView: View {
    let name: String = "Oh Ye Jun"
    let email: String = "123@123.com"
    var body: some View {
            VStack {
                Text("\(name)")
                    .bold()
                    .font(.title)
                    .foregroundColor(Color("textColor"))
                Text("\(email)")
                    .font(.body)
                    .foregroundColor(Color("textColor"))
            }
    }
}
struct SignView: View {
    var body: some View {
        VStack {
            Text("전자 서명 확인 및 수정")
        }
    }
}
struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(sideMenuControl: .constant(true))
    }
}
