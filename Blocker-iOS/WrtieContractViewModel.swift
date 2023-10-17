//
//  WrtieContractViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/12.
//

import Foundation

class WrtieContractViewModel:ObservableObject {
    func writeContract(_ title:String, _ content:String) {
        BlockerServer.shared.writeContract(title, content) { result in
            switch result {
            case .success(let statusCode):
                print("success")
            case .failure(let APIError):
                print("success")
            }
        }
    }
    
    func patchContract(_ contractData:Contract) {
        BlockerServer.shared.patchContract(contractData) { state, statusCode in
            if state {
                
            } else {
                
            }
        }
    }
    
}
