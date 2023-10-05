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
    @State var isShowingEditPost:Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text(postViewModel.postResponseData?.title ?? "none title")
                        .font(.title)
                    HStack {
                        VStack {
                            HStack {
                                Text("작성일:")
                                Text(postViewModel.postResponseData?.createdAt.split(separator: "T").first! ?? "")
                            }
                            HStack {
                                Text("수정일:")
                                Text(postViewModel.postResponseData?.modifiedAt.split(separator: "T").first! ?? "")
                            }
                        }
                        .padding(.leading, 20)
                        Spacer()
                        Text(postViewModel.postResponseData?.name ?? "none writer")
                            .font(.body)
                            .padding(.trailing, 20)
                    }
                }
                Divider()
                if let data = postViewModel.postResponseData?.images {
                    Divider()
                    PostImageView(imageResponseData:data, imageType: .PostImage)
                }
                Divider()
                VStack(alignment: .leading) {
                    Text(postViewModel.postResponseData?.content ?? "none")
                        .foregroundColor(Color("textColor"))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                Spacer()
                HStack{
                    HStack {
                        Image(systemName: "eye.fill")
                        Text(String(postViewModel.postResponseData?.view ?? 0))
                        Image(systemName: "heart.fill")
                        Text(String(postViewModel.postResponseData?.bookmarkCount ?? 0))
                    }
                    .padding(.leading, 20)
                    Spacer()
                    NavigationLink(destination: NotSignedContract(contractId: postViewModel.postResponseData?.contractId ?? 10)) {
                        Text("Imported Contract")
                    }
                    .padding(.trailing, 20)
                }
            }
            .onAppear {
                postViewModel.getPostData(boardId)
            }
        }
        .toolbar {
            Menu {
                if let isWriter = postViewModel.postResponseData?.isWriter {
                    if isWriter {
                        Button {
                            self.isShowingEditPost = true
                        } label: {
                            Label("Edit", systemImage: "pencil.circle")
                        }
                        Button(action: {
                            postViewModel.deletePost(postViewModel.postResponseData!.boardId)
                            dismiss()
                        }) {
                            Label("Delete", systemImage: "trash.circle")
                        }
                    }
                }
                Button(action: {
                    postViewModel.addBookmark(boardId)
                }) {
                    if let heart = postViewModel.postResponseData?.isBookmark {
                        if heart {
                            Label("Delete Bookmark", systemImage: "heart.fill")
                        } else {
                            Label("Add Bookmark", systemImage: "heart")
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
            }
            .background(
                NavigationLink(destination: EditPostView(editingPost: postViewModel.postResponseData) ?? nil, isActive: $isShowingEditPost) {
                    EmptyView()
                }
            )
        }
    }
}

struct PostImageView: View {
    @State var imageResponseData:[ImageResponseData]
    @State var imageType:BlockerImageType
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(imageResponseData, id: \.imageId) { image in
                    Button(action: { print(image.imageAddress)}) {
                        AsyncImageView(imageURL: image.imageAddress, imageType: .PostImage)
                    }
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
