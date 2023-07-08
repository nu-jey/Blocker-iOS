//
//  SigningContractView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/08.
//

import SwiftUI

struct SigningContractView: View {
    @State var title:String = "title"
    @State var content:String = "content"
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            Divider()
            Spacer()
            Text(content)
                .font(.body)
            Spacer()
            Divider()
            ContractorsSignView()
            Divider()
            HStack {
                Button("Sign") {
                    // 전자 서명
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
                Button("Cancel") {
                    // 계약 취소
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
struct ContractorsSignView: View {
    var body: some View {
        Text("계약 참여자들 서명 뷰 ")
    }
}
struct SigningContractView_Previews: PreviewProvider {
    static var previews: some View {
        SigningContractView()
    }
}
