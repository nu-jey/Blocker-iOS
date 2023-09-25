//
//  Blocker++Bundle.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/07.
//

import Foundation

import Foundation

extension Bundle {
    var host: String? {
        guard let file = self.path(forResource: "Host", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["Host"] as? String else { fatalError("error")}
        return key
    }
}
