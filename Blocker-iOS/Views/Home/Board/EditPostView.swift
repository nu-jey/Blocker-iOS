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
    @State var additionalImage:[UIImage] = []
    @State private var showModal:Bool = false
    @State var editingPost:PostResponseData?
    @StateObject var notSignedContractViewModel:NotSignedContractViewModel = NotSignedContractViewModel()
    @StateObject var eidtPostViewModel:EidtPostViewModel = EidtPostViewModel()
    @State var removeImageIndex:[Int] = []
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
                    HStack {
                        Button(action: { showModal = true }) {
                            Text("Load Contract")
                        }
                        .padding(.leading, 20)
                        Spacer()
                        Text(contractTitle ?? "preselected Contract")
                            .padding(.trailing, 20)
                    }
                    Divider()
                    if editingPost != nil {
                        EditPostImageLoadView(existingImage: editingPost!.images, additionalImage: $additionalImage, removeImageIndex: $removeImageIndex)
                    }
                    Divider()
                    // PostLocationInfoView()
                    Divider()
                }
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
                    var newEditedPost = EditedPost(title: title, content: content, info: info, representImage: nil, contractId: contractId!, images: [])
                    newEditedPost.deleteImageIds = removeImageIndex
                    eidtPostViewModel.patchPost(newEditedPost, editingPost!.boardId, additionalImage)
                    // dismiss()
                }
            }
            ContractListModalView(contractId: $contractId, contractTitle: $contractTitle, isShowing: $showModal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if editingPost != nil {
                notSignedContractViewModel.getNotSignedContract((editingPost?.contractId)!)
                contractTitle = notSignedContractViewModel.notSignedContractResponseData?.title
                title = editingPost!.title
                content = editingPost!.content
                contractId = editingPost!.contractId
                info = editingPost!.info
            }
        }
    }
}


struct EditPostImageLoadView:View {
    @State var existingImage:[ImageResponseData]
    @Binding var additionalImage:[UIImage]
    @State var isPresentedSheet = false
    @Binding var removeImageIndex:[Int]
    
    func imageOpacity(_ idx:Int) -> Double {
        if removeImageIndex.contains(idx) {
            return 0.5
        } else {
            return 1
        }
    }
    var body: some View {
        VStack {
            HStack { // 게시글 이미지
                Button("Load Images") {
                    self.isPresentedSheet = true
                } .fullScreenCover(isPresented: self.$isPresentedSheet, content: {
                    ImagePickerCoordinatorView(images: $additionalImage)
                })
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(existingImage, id: \.imageId) { image in
                        ZStack(alignment: .topTrailing) {
                            AsyncImageView(imageURL: image.imageAddress, imageType: .PostImage)
                                .opacity(imageOpacity(image.imageId))
                            Button(action: {
                                // 삭제 이미지 토글
                                if removeImageIndex.contains(image.imageId) {
                                    removeImageIndex.remove(at: removeImageIndex.firstIndex(of: image.imageId)!)
                                } else {
                                    removeImageIndex.append(image.imageId)
                                }
                            }) {
                                if removeImageIndex.contains(image.imageId) {
                                    Image(systemName: "plus.circle.fill")
                                } else {
                                    Image(systemName: "x.circle.fill")
                                }
                            }
                            .foregroundColor(Color("signatureColor1"))
                        }
                    }
                    ForEach(additionalImage, id: \.self) { image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10, corners: .allCorners)
                            Button(action: {
                                additionalImage.remove(at: additionalImage.firstIndex(of: image)!)
                            }) {
                                Image(systemName: "x.circle.fill")
                            }
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
