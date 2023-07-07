//
//  EditPostView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/07.
//

import SwiftUI

struct EditPostView: View {
    @State var title:String = ""
    @State var content:String = ""
    @State var contractTitle:String = "contract"
    var body: some View {
        VStack {
            TextField("Enter title", text: $title)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
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
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                TextEditor(text: $content)
                    .padding()
                    .cornerRadius(10)
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .colorMultiply(Color(uiColor: .secondarySystemBackground))
            }
            Divider()
            HStack {
                Button("Save") {
                    // 게시글 저장
                }
            }
            
        }
    }
}

struct EditPostView_Previews: PreviewProvider {
    static var previews: some View {
        EditPostView()
    }
}
