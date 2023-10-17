//
//  SignedContractViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/10/17.
//

import Foundation

class SignedContractViewModel:ObservableObject {
    func getContractData(_ contractId: Int) {
        
    }
    
    func cancelSignedContract(_ contractId: Int) {
        BlockerServer.shared.cancelSignedContract(contractId) { result in
            switch result {
            case .success(let statusCode):
                print("success: \(statusCode)")
            case .failure(let APIError):
                switch APIError {
                case .BADREQUEST:
                    print("BADREQUEST")
                case .FORBIDDEN:
                    print("FORBIDDEN")
                case .UNAUTHORIZATION:
                    print("UNAUTHORIZATION")
                case .NOTFOUND:
                    print("NOTFOUND")
                }
            }
        }
    }
}
