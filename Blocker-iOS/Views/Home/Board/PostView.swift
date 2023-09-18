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
            if let data = postViewModel.postResponseData?.images {
                PostImageView(imageResponseData:data, iamgeType: .PostImage)
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
        .toolbar {
            Button(action: { print("123") }) {
                if postViewModel.postResponseData?.isWriter ?? false {
                    Image(systemName: "pencil")
                }
            }
        }
    }
}

struct PostImageView: View {
    @State var imageResponseData:[ImageResponseData]
    @State var iamgeType:BlockerImageType
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(imageResponseData, id: \.imageId) { image in
                    AsyncImageView(imageURL: image.imageAddress, imageType: iamgeType)
                }
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(boardId: 27)
    }
}
