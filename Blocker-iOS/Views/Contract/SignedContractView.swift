//
//  SignedContractView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/08.
//

import SwiftUI

struct SignedContractView: View {
    @State var contractId:Int
    @State var title:String = "title"
    @State var content:String = "content"
    @State var writer:String = "writer"
    @StateObject var signedContractViewModel:SignedContractViewModel = SignedContractViewModel()
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
            //ContractorsSignView()
            Divider()
            HStack {
                Button("PDF") {
                    let signedContract = SignedContract(title: title, content: content, writer: writer, contractors: [], signatures: [])
                    signedContract.convertPDF()
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
                Button("Terminate") {
                    // 계약 파기
                    signedContractViewModel.cancelSignedContract(contractId)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
            }
            .padding()
            .frame(height: 100)
        }
        .onAppear {
            signedContractViewModel.getContractData(contractId)
        }
    }
}

struct SignedContractView_Previews: PreviewProvider {
    static var previews: some View {
        SignedContractView(contractId: 1)
    }
}
