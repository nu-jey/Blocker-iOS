//
//  SigningContractViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/10/04.
//

import Foundation

class SigningContractViewModel:ObservableObject {
    func signOnContract(_ contractId: Int) {
        BlockerServer.shared.signOnContract(contractId) { state, statusCode in
            if state {
                
            } else {
                
            }
        }
    }
}
