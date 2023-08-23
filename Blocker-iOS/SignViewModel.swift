//
//  SignViewModel.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/23.
//

import Foundation
import UIKit

class SignViewModel: ObservableObject {
    func updateSign(_ image: UIImage) -> (Bool,String) {
        var message:String = ""
        var res: Bool = false
        BlockerServer.shared.updateSignature(image) { state, statusCode  in
            if state {
                res = true
            } else {
                if statusCode == 204 {
                    message = "204"
                } else if statusCode == 401 { // 토큰 만료
                    message = "401"
                    BlockerServer.shared.reissueToken() { state, statusCode in
                        if state {
                            // 재발급 성공
                        } else {
                            if statusCode == 401 {
                                // 로그인 페이지로 이동 
                            }
                        }
                    }
                } else if statusCode == 403 { // 전자서명 저장 실패
                    message = "403"
                } else if statusCode == 500 { // INTERNAL SERVER ERROR
                    message = "500"
                }
            }
        }
        return (res, message)
    }
}

