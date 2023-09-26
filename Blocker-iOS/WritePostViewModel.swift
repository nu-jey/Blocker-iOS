//
//  WritePostViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/17.
//

import Foundation
import UIKit
class WritePostViewModel:ObservableObject {
    func writePost(_ post:Post, _ images:[UIImage])  {
        let dispatchGroup = DispatchGroup()
        if !images.isEmpty {
            for image in images {
                dispatchGroup.enter()
                BlockerServer.shared.saveImage(image) { state, statusCode, urlValue in
                    if state {
                        post.images.append(urlValue)
                        print(urlValue)
                    } else {
                        
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            post.representImage = post.images.first ?? nil
            BlockerServer.shared.writePost(post) { state, statusCode in
                if state {

                } else {

                }
            }
        }
        
    }
    
    func saveImages(_ images:[UIImage]) -> [String]? {
        var res:[String] = []
        for image in images {
            BlockerServer.shared.saveImage(image) { state, statusCode, urlValue in
                if state {
                    res.append(urlValue)
                } else {
                    
                }
            }
        }
        return res
    }
    
    func patchPost(_ post:EditedPost, _ images:[UIImage], _ boardId:Int) {
        var imageValue = saveImages(images)
        if !images.isEmpty {
            post.images = imageValue!
            post.representImage = imageValue!.first!
        }
        BlockerServer.shared.patchPost(post, boardId) { state, statusCode in
            if state {
                
            } else {
                
            }
        }
    }
}
