//
//  Utils.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/22.
//

import Foundation

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

// 로그인 상태
enum SignInState {
  case signedIn
  case signedOut
  case signautreNeeded
}
