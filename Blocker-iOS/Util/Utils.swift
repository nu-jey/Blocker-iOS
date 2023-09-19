//
//  Utils.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/22.
//

import Foundation
import SwiftUI

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

// 계약서 상태
enum ContractType {
    case notSigned
    case signing
    case signed
}

extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

enum BlockerImageType {
    case BoardImage
    case PostImage
}
