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
    @StateObject var myPageViewModel:MyPageViewModel = MyPageViewModel()
    let myPost = 1
    let favorites = 2
    var body: some View {
        VStack {
            VStack {
                ProfileHeaderView()
                ProfileFooterView()
            }
            Spacer()
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Post")
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color("backgroundColor"))
                        .frame(height: 100)
                        .padding()
                    HStack(spacing: 8.0) {
                        VStack {
                            Text("작성 게시글")
                            Button("\(myPost)") {
                                print("작성한 게시글 목록 리스트 업")
                            }
                            .padding(.top, 5)
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("관심 목록")
                            Button("\(favorites)") {
                                print("관심 목록 리스트 업")
                            }
                            .padding(.top, 5)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                HStack {
                    Text("Contracts")
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color("backgroundColor"))
                        .frame(height: 100)
                        .padding()
                    HStack(spacing: 8.0) {
                        VStack {
                            Text("진행 중 계약서")
                            Button("\(myPost)") {
                                print("진행 중인 계약서 상태 목록")
                            }
                            .padding(.top, 5)
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("체결 계약서")
                            Button("\(favorites)") {
                                print("체결된 계약서 상태 목록")
                            }
                            .padding(.top, 5)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                HStack {
                    Text("Electronioc Signature")
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color("backgroundColor"))
                        .frame(height: 100)
                        .padding()
                    HStack(spacing: 8.0) {
                        Button("Check Sign") {
                            print("기존 서명 이미지 불러오기 ")
                        }
                        .frame(maxWidth: .infinity)
                        Button(action: {signViewModalControl = true} ) {
                            Text("Resign")
                        }
                            .sheet(isPresented: $signViewModalControl) {
                                // SignView(launchViewModel: <#LaunchViewModel#>)
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .background(Color("subBackgroundColor"))
            .cornerRadius(10)
            .ignoresSafeArea()
        }
        .onAppear {
            myPageViewModel.getBookmark()
            myPageViewModel.getMyPost()
        }
    }
    
}

struct ProfileHeaderView: View {
    var body: some View {
            ZStack(alignment: .top){
                Rectangle()
                    .foregroundColor(Color("subBackgroundColor"))
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 70)
                VStack {
                    Image(systemName: "person")
                        .resizable()
                        .padding()
                        .background(Color.gray)
                        .scaledToFit()
                        .clipShape(Circle().inset(by: 5))
                        .frame(width: 100)
                }
                .padding(.top, 20)
            }
    }
}
struct ProfileFooterView: View {
    let user:UserResponseData = BlockerServer.shared.getOwnData()
    let name: String = "Oh Ye Jun"
    let email: String = "123@123.com"
    var body: some View {
            VStack {
                Text(user.name)
                    .bold()
                    .font(.title)
                    .foregroundColor(Color("textColor"))
                Text(user.email)
                    .font(.body)
                    .foregroundColor(Color("textColor"))
            }
    }
}
struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(sideMenuControl: .constant(true))
    }
}
