//
//  PostViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/26.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var postResponseData:PostResponseData?
    
    func getPostData(_ boardId: Int) {
        BlockerServer.shared.getPostData(boardId) { state, statusCode, data in
            if state {
                DispatchQueue.main.async { [weak self] in
                    self?.postResponseData = data
                    print(data)
                }
            } else {
                if statusCode == 401 {
                    
                } else if statusCode == 403 {
                    
                }
            }
        }
    }
}
