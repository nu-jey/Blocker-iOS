//
//  PostView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/05.
//

import SwiftUI

struct PostView: View {
    @State var postViewModel:PostViewModel = PostViewModel()
    @State var boardId:Int
    @State var contractModalControl: Bool = false
    var body: some View {
        VStack {
            VStack {
                Text(postViewModel.postResponseData?.title ?? "none title")
                    .font(.title)
                HStack {
                    Spacer()
                    Text(postViewModel.postResponseData?.name ?? "none writer")
                        .font(.body)
                        .padding(.trailing, 20)
                }
                Button("print") {
                    print(postViewModel.postResponseData)
                }
            }
            Divider()
            Spacer()
            Text(postViewModel.postResponseData?.content ?? "none")
                .foregroundColor(Color("textColor"))
            Spacer()
            Divider()
            HStack {
                Button("Contract") {
                    contractModalControl = true
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
                .sheet(isPresented: $contractModalControl) {
                    ContractView()
                }
                Button("Add Bookmark") {
                    // 관심 목록 추가
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
            }
            .padding()
            .frame(height: 100)
        }
        .onAppear {
            postViewModel.getPostData(boardId)
        }
    
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(boardId: 1)
    }
}
