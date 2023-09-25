//
//  ProceedContractViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/25.
//

import Foundation

class ProceedContractViewModel:ObservableObject {
    @Published var contrators:[UserResponseData]?
    
    func searchUser(_ keyword:String) {
        BlockerServer.shared.searchUser(keyword) { state, statuCode, data in
            if state {
                DispatchQueue.main.async {
                    self.contrators = data
                }
            } else {
                
            }
        }
    }
    
    func proceedContract(_ contractId:Int, _ contractors:[String]) {
        BlockerServer.shared.proceedContract(contractId, contractors) { state, statusCode in
            if state {
                
            } else {
                
            }
        }
    }
}
