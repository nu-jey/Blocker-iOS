//
//  Constant.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/04.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

struct ConstantData {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let allowedFileType: [UTType] = [.audio,.image,.pdf]
    static let imagePickerSelectionMax:Int = 5
}
