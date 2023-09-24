//
//  EditPostView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/21.
//

import SwiftUI

struct EditPostView: View {
    @State var title:String = ""
    @State var content:String = ""
    @State var contractTitle:String? = nil
    @State var contractId:Int? = nil
    @State var info:String?
    @State var images:[UIImage] = []
    @State private var showModal:Bool = false
    @State var editingPost:PostResponseData?
    @StateObject var notSignedContractViewModel:NotSignedContractViewModel = NotSignedContractViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("Enter title", text: $title)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding()
                Divider()
                Group {
                    HStack { // 계약서
                        Button(action: { showModal = true }) {
                            // 미체결 계약서 목록
                            Text("Load Contract")
                        }
                        .padding(.leading, 20)
                        Spacer()
                        Text(contractTitle ?? "preselected Contract")
                            .padding(.trailing, 20)
                    }
                    Divider()
                    //EditPostImageLoadView(editingPost: editingPost)
                    Divider()
                    PostLocationInfoView()
                    Divider()
                }
                Group {
                    TextEditor(text: $content)
                        .cornerRadius(10)
                        .font(.body)
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                        .foregroundColor(Color("textColor"))
                        .background(Color(uiColor: .secondarySystemBackground))
                        .scrollContentBackground(.hidden)
                        .padding()
                    Divider()
                    Button("Save") {
                        dismiss()
                    }
                }
            }
            ContractListModalView(contractId: $contractId, contractTitle: $contractTitle, isShowing: $showModal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            notSignedContractViewModel.getNotSignedContract((editingPost?.contractId)!)
            contractTitle = notSignedContractViewModel.notSignedContractResponseData?.title
        }
    }
}


struct EditPostImageLoadView:View {
    @Binding var editingPost:PostResponseData
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(editingPost.images, id: \.imageId) { image in
                    ZStack(alignment: .topTrailing) {
                        AsyncImageView(imageURL: image.imageAddress, imageType: .PostImage)
                        Button(action: {
                            print(image.imageId)
                        }) {
                            Image(systemName: "x.circle.fill")
                        }
                    }
                }
            }
        }
    }
}

struct EditPostView_Previews: PreviewProvider {
    static var previews: some View {
        EditPostView(editingPost: PostResponseData(boardId: 7, title: "title", content: "content", name: "oh yejun", representImage: "", view: 1, bookmarkCount: 1, createdAt: "createdAt", modifiedAt: "modifiedAt", images: [], info: nil, contractId: 7, isWriter: true, isBookmark: false))
    }
}
