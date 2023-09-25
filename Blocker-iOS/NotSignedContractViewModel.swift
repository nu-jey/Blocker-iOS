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
        BlockerServer.shared.deleteContract(contractId) { state, statusCode in
            print(statusCode)
            if state {
                
            } else {
                
            }
            
        }
    }
    
}
