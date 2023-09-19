//
//  WritePostView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/07.
//

import SwiftUI
import BSImagePicker

struct WritePostView: View {
    @State var title:String = ""
    @State var content:String = ""
    @State var contractTitle:String? = nil
    @State var contractId:Int? = nil
    @State var info:String?
    @State var images:[UIImage] = []
    @State private var showModal:Bool = false
    @StateObject var writePostViewModel:WritePostViewModel = WritePostViewModel()
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
                        Text(contractTitle ?? "not selected")
                            .padding(.trailing, 20)
                        
                    }
                    Divider()
                    PostImageLoadView(images: $images)
                    Divider()
                    PostLocationInfoView()
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
                    writePostViewModel.writePost(Post(title: title, content: content, info: nil, representImage: nil, contractId: contractId!, images: []), images)
                    dismiss()
                }
            }
            ContractListModalView(contractId: $contractId, contractTitle: $contractTitle, isShowing: $showModal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PostImageLoadView:View {
    @State var isPresentedSheet = false
    @Binding var images:[UIImage]
    var body: some View {
        HStack { // 게시글 이미지
            Button("Load Images") {
                self.isPresentedSheet = true
            } .fullScreenCover(isPresented: self.$isPresentedSheet, content: {
                ImagePickerCoordinatorView(images: $images)
            })
            Button("Image Data") {
                print(images)
            }
        }
    }
}

struct PostLocationInfoView:View {
    @State var isPresentedSheet = false
    var body: some View {
        HStack {
            Button("Import Location") {
                self.isPresentedSheet = true
            } .fullScreenCover(isPresented: self.$isPresentedSheet, content: {
                TempWebView()
            })
        }
    }
}

struct TempWebView:View {
    var body: some View {
        Text("123")
    }
}
struct WritePostView_Previews: PreviewProvider {
    static var previews: some View {
        WritePostView()
    }
}
