//
//  PostView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/05.
//

import SwiftUI

struct PostView: View {
    @State var title: String = "title"
    @State var content: String = "content"
    @State var writer: String = "userID"
    @State var contractModalControl: Bool = false
    var body: some View {
        VStack {
            PostHeaderView(title: $title, writer: $writer)
            Divider()
            Spacer()
            PostFooterView(content: $content)
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
                .sheet(isPresented: $contractModalControl) {
                    ContractView()
                }
                Button("Add Bookmark") {
                    // 관심 목록 추가
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
            }
            .padding()
            .frame(height: 100)
            
        }
    
    }
}
struct PostHeaderView: View {
    @Binding var title: String
    @Binding var writer: String
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            HStack {
                Spacer()
                Text(writer)
                    .font(.body)
                    .padding(.trailing, 20)
            }
        }
    }
}
struct PostFooterView: View {
    @Binding var content: String
    var body: some View {
        VStack {
            Text(content)
        }
    }
}
struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
