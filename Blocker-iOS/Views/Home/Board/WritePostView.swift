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
    @State var contractTitle:String = "contract"
    @State var contractId:Int?
    @State var info:String?
    @State var representImage:UIImage?
    @State var images:[UIImage] = []
    var body: some View {
        Group {
            VStack {
                HStack {
                    TextField("Enter title", text: $title)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding()
                Divider()
                HStack { // 계약서
                    Button("Load Contract") {
                        // 미체결 계약서 목록
                    }
                    .padding(.leading, 20)
                    Spacer()
                    Text(contractTitle)
                        .padding(.trailing, 20)
                    
                }
                Divider()
                PostImageLoadView(images: images)
                Divider()
                PostLocationInfoView()
                Divider()
                TextEditor(text: $content)
                    .cornerRadius(10)
                    .font(.body)
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .foregroundColor(Color("textColor"))
                    .background(Color(uiColor: .secondarySystemBackground))
                    .scrollContentBackground(.hidden)
                    .padding()
                Divider()
//                HStack {
//                    Button("Save") {
//                        // 게시글 저장
//                        print(title, content, info, representImage, contractId, images)
//                    }
//                }
            }
        }
    }
}
struct PostImageLoadView:View {
    @State var isPresentedSheet = false
    @State var images:[UIImage]
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
