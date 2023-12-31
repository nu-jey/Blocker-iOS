//
//  EidtPostViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/21.
//

import Foundation
import UIKit

class EidtPostViewModel:ObservableObject {
    func patchPost(_ editedPost: EditedPost, _ boardId: Int, _ newImages: [UIImage]) {
        let dispatchGroup = DispatchGroup()
        if !newImages.isEmpty {
            for image in newImages {
                dispatchGroup.enter()
                BlockerServer.shared.saveImage(image) { state, statusCode, urlValue in
                    if state {
                        editedPost.addImageAddresses.append(urlValue)
                    } else {
                        
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("----")
            print(editedPost.addImageAddresses)
            BlockerServer.shared.patchPost(editedPost, boardId) { state, statusCode in
                if state {
    
                } else {
    
                }
            }
        }
        
        
        
    }
}
