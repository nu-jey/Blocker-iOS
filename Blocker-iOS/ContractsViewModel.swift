//
//  ContractsViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/12.
//

import Foundation

class ContractsViewModel: ObservableObject {
    @Published var notSigendContractListResponseData:[ContractResponseData] = []
    @Published var signingContractListResponseData:[ContractResponseData] = []
    @Published var signedContractListResponseData:[ContractResponseData] = []
    
    func getContractListResponseData(_ contractType:ContractType) {
        BlockerServer.shared.getContractListData(contractType) {  state, statusCode, data in
            if state {
                DispatchQueue.main.async { [weak self] in
                    if contractType == .notSigned {
                        self!.notSigendContractListResponseData = data
                    } else if contractType == .signing {
                        self!.signingContractListResponseData = data
                    } else {
                        self!.signedContractListResponseData = data
                    }
                    print(data)
                }
            } else {
                
            }
            
        }
    }
}
