//
//  BoardViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/24.
//

import Foundation

class BoardViewModel: ObservableObject {
    @Published var boardResponseData:[BoardResponseData] = []
    func getBoardData(_ size:Int, _ page: Int) {
        BlockerServer.shared.getBoardData(size, page) { state, statusCode, data in
            if state {
                DispatchQueue.main.async { [weak self] in
                    self?.boardResponseData = data
                }
            } else {
                if statusCode == 401 {
                    
                } else if statusCode == 403 {
                    
                }
            }
        }
    }
}
