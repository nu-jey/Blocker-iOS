//
//  WriteContractView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/06.
//

import SwiftUI

struct WriteContractView: View {
    @Environment(\.dismiss) private var dismiss
    @State var title:String = ""
    @State var content:String = ""
    @StateObject var writeContractViewModel:WrtieContractViewModel = WrtieContractViewModel()
    @State var contractData:Contract?
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
                    if contractData == nil {
                        writeContractViewModel.writeContract(title, content)
                        dismiss()
                    } else {
                        writeContractViewModel.patchContract(Contract(contractId: contractData!.contractId, title: title, content: content))
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if contractData != nil {
                self.title = contractData!.title
                self.content = contractData!.content
            }
        }
    }
}

struct WriteContractView_Previews: PreviewProvider {
    static var previews: some View {
        WriteContractView()
    }
}
