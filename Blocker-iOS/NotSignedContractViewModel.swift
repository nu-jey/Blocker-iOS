//
//  NotSignedContractViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/12.
//

import Foundation

class NotSignedContractViewModel:ObservableObject {
    @Published var notSignedContractResponseData:ContractResponseData?
    func getNotSignedContract(_ contractId: Int) {
        BlockerServer.shared.getContractData(contractId) { state, statucCode, data in
            if state {
                DispatchQueue.main.async {
                    self.notSignedContractResponseData = data
                }
            } else {
                
            }
        }
    }
    
    func deleteNotSignedContract(_ contractId: Int) {
        BlockerServer.shared.deleteContract(contractId) { result in
            switch result {
            case .success(let statusCode):
                print("success: \(statusCode)")
            case .failure(let APIError):
                switch APIError {
                case .BADREQUEST:
                    print("BADREQUEST")
                    self.deleteContractAndPost(contractId)
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
    
    func deleteContractAndPost(_ contractId: Int) {
        BlockerServer.shared.deleteContractAndPost(contractId) { result in
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
