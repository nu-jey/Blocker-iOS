//
//  WriteContractView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/06.
//

import SwiftUI

struct WriteContractView: View {
    @State var title:String = ""
    @State var content:String = ""
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

struct WriteContractView_Previews: PreviewProvider {
    static var previews: some View {
        WriteContractView()
    }
}
