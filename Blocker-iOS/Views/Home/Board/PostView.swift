//
//  PostView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/05.
//

import SwiftUI

struct PostView: View {
    @StateObject var postViewModel:PostViewModel = PostViewModel()
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
            }
            Divider()
            PostImageView(iamgeString: postViewModel.postResponseData?.representImage ?? "")
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
                .fullScreenCover(isPresented: $contractModalControl) {
                    ContractView()
                }
                Button("Add Bookmark") {
                    postViewModel.addBookmark(boardId)
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
struct PostImageView: View {
    @State var iamgeString:String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                AsyncImageView(iamgeURL: iamgeString)
                AsyncImageView(iamgeURL: iamgeString)
                AsyncImageView(iamgeURL: iamgeString)
                AsyncImageView(iamgeURL: iamgeString)
                AsyncImageView(iamgeURL: iamgeString)
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(boardId: 1)
    }
}
