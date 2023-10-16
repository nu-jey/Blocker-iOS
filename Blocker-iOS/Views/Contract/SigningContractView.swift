//
//  SigningContractView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/08.
//

import SwiftUI

struct SigningContractView: View {
    @State var contractId:Int
    @StateObject var signingContractViewModel:SigningContractViewModel = SigningContractViewModel()
    var body: some View {
        VStack {
            Text(signingContractViewModel.signingContractResponseData?.title ?? "")
                .font(.title)
            Divider()
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(signingContractViewModel.signingContractResponseData?.contractorAndSignStates ?? [], id: \.contractor) { data in
                        HStack {
                            Text(data.contractor)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(data.signState == "Y" ? Color("signatureColor2"):Color("signatureColor1"))
                        }
                    }
                }
            }
            Divider()
            Spacer()
            ScrollView(.vertical) {
                Text(signingContractViewModel.signingContractResponseData?.content ?? "")
                    .font(.body)
            }
            Spacer()
            Divider()
            HStack {
                Button("Sign") {
                    signingContractViewModel.signOnContract(contractId)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
                Button("Cancel") {
                    // 계약 취소
                    signingContractViewModel.cancelSigningContract(contractId)
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
            signingContractViewModel.getSigningContract(contractId)
        }
    }


}

struct SigningContractView_Previews: PreviewProvider {
    static var previews: some View {
        SigningContractView(contractId: 0)
    }
}
