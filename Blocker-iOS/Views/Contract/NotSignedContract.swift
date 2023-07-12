//
//  NotSignedContract.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/08.
//

import SwiftUI

struct NotSignedContract: View {
    @State var title:String = "title"
    @State var content:String = "content"
    @State var writer:String = "writer"
    @State var contractorsModalControl:Bool = false
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
            HStack {
                Button("Proceed") {
                    contractorsModalControl = true
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
                .sheet(isPresented: $contractorsModalControl) {
                    ProceedContractView()
                }
                NavigationLink(destination: WriteContractView()){
                    Text("Edit")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color("subBackgroundColor"))
                    .cornerRadius(5)
                }
            }
            .padding()
            .frame(height: 100)
        }
    }
}
struct ProceedContractView: View {
    var body: some View {
        Text("계약 참여자 추가 -> 계약 진행 ")
    }
}
struct NotSignedContract_Previews: PreviewProvider {
    static var previews: some View {
        NotSignedContract()
    }
}
