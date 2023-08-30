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
    
    func addBookmark(_ boardId: Int) {
        var alreadyAdded:Bool = false
        BlockerServer.shared.addBookmark(boardId) { state, statusCode in
            if state {
                print("등록 성공")
            } else {
                print("등록 실패: \(statusCode)")
                if statusCode == 401 {
                    
                } else if statusCode == 403 {
                    
                } else if statusCode == 409 {
                    print("삭제 진행")
                    self.deleteBookmark(boardId)
                }
            }
        }
    }
    
    func deleteBookmark(_ boardId: Int) {
        BlockerServer.shared.deleteBookmark(boardId) { state, statusCode in
            if state {
                print("삭제 성공")
            } else {
                print("삭제 실패: \(statusCode)")
                if statusCode == 401 {
                    
                } else if statusCode == 403 {
                    
                } 
            }
        }
    }
    
}


