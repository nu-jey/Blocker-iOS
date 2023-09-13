//
//  NotSignedContract.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/08.
//

import SwiftUI

struct NotSignedContract: View {
    @StateObject var  notSignedContractViewModel:NotSignedContractViewModel = NotSignedContractViewModel()
    @State var contractId:Int
    @State var contractorsModalControl:Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
            VStack {
                Text(notSignedContractViewModel.notSignedContractResponseData?.title ?? "")
                    .font(.title)
                Divider()
                Spacer()
                Text(notSignedContractViewModel.notSignedContractResponseData?.content ?? "")
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
                    .fullScreenCover(isPresented: $contractorsModalControl) {
                        ProceedContractView()
                    }
                    NavigationLink(destination: WriteContractView(contractData: Contract(contractId: contractId, title: notSignedContractViewModel.notSignedContractResponseData?.title ?? "", content: notSignedContractViewModel.notSignedContractResponseData?.content ?? ""))){
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
            .onAppear {
                self.notSignedContractViewModel.getNotSignedContract(contractId)
            }
            .toolbar {
                Button("Delete") {
                    self.notSignedContractViewModel.deleteNotSignedContract(contractId)
                    dismiss()
                }
            }
        }
}
struct ProceedContractView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Text("계약 참여자 추가 -> 계약 진행 ")
            Button("Back") {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
struct NotSignedContract_Previews: PreviewProvider {
    static var previews: some View {
        NotSignedContract(contractId: 3)
    }
}
