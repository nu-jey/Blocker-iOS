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
    @State var isPresentedSheet = false
    var body: some View {
        VStack {
            HStack {
                TextField("Enter title", text: $title)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
            }
            .padding()
            Divider()
            HStack {
                Button("Load Contract") {
                    // 미체결 계약서 목록
                }
                .padding(.leading, 20)
                Spacer()
                Text(contractTitle)
                    .padding(.trailing, 20)
                
            }
            Divider()
            HStack {
                Button("Load Images") {
                    self.isPresentedSheet = true
                } .sheet(isPresented: self.$isPresentedSheet, content: {
                    ImagePickerCoordinatorView()
                })
            }
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
            HStack {
                Button("Save") {
                    // 게시글 저장
                }
            }
            
        }
    }
}
