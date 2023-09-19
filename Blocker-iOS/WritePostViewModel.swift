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
        var imageValue = saveImages(images)
        if !images.isEmpty {
            post.images = imageValue
            post.representImage = imageValue.first!
        }
        BlockerServer.shared.wirtePost(post) { state, statusCode in
            if state {
                
            } else {
                
            }
        }
    }
    
    func saveImages(_ images:[UIImage]) -> [String]{
        var res:[String] = []
        for image in images {
            BlockerServer.shared.saveImage(image) { state, statusCode, urlValue in
                if state {
                    res.append(urlValue)
                } else {
                    
                }
            }
        }
        print("이미지 변환:\(res)")
        return res
    }
}
