//
//  MyPageViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/10/17.
//

import Foundation

class MyPageViewModel:ObservableObject {
    @Published var myPost:[BoardResponseData] = []
    @Published var bookmark:[BoardResponseData] = []
    func getMyPost() {
        BlockerServer.shared.getMyPost() { result in
            switch result {
            case .success(let postData):
                DispatchQueue.main.async { [weak self] in
                    self!.myPost = postData
                }
                print(postData)
            case .failure(.UNAUTHORIZATION):
                print("UNAUTHORIZATION")
            case .failure(.BADREQUEST):
                print("BADREQUEST")
            case .failure(.FORBIDDEN):
                print("FORBIDDEN")
            case .failure(.NOTFOUND):
                print("NOTFOUND")
            }
        }
    }
    
    func getBookmark() {
        BlockerServer.shared.getBookmark() { result in
            switch result {
            case .success(let postData):
                DispatchQueue.main.async { [weak self] in
                    self!.bookmark = postData
                }
                print(postData)
            case .failure(.UNAUTHORIZATION):
                print("UNAUTHORIZATION")
            case .failure(.BADREQUEST):
                print("BADREQUEST")
            case .failure(.FORBIDDEN):
                print("FORBIDDEN")
            case .failure(.NOTFOUND):
                print("NOTFOUND")
            }
        }
    }
}
