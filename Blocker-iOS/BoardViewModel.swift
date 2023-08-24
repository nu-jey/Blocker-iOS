//
//  BoardViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/24.
//

import Foundation

class BoardViewModel: ObservableObject {
        
    func getBoardData(_ size:Int, _ page: Int) {
        BlockerServer.shared.getBoardData(size, page) { state, statusCode in
            if state {
                
            } else {
                if statusCode == 401 {
                    
                } else if statusCode == 403 {
                    
                }
            }
        }
    }
}
