//
//  SigningContractViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/10/04.
//

import Foundation

class SigningContractViewModel:ObservableObject {
    @Published var signingContractResponseData:SigningContractResponseData?
    func signOnContract(_ contractId: Int) {
        BlockerServer.shared.signOnContract(contractId) { state, statusCode in
            if state {
                
            } else {
                
            }
        }
    }
    
    func getSigningContract(_ contractId: Int) {
        BlockerServer.shared.getSigningContractData(contractId: contractId) { state, statusCode, data in
            if state {
                DispatchQueue.main.async { [weak self] in
                    self!.signingContractResponseData = data
                }
            } else {
                
            }
        }
    }
    
    func cancelSigningContract(_ contractId: Int) {
        BlockerServer.shared.cancelSigningContract(contractId) { state, stausCode in
            if state {
                print("진행중 계약 파기 성공 ")
            } else {
                print(stausCode)
            }
        }
    }
}
