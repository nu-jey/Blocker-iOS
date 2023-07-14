//
//  Verification.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/12.
//

import Foundation
import PDFKit
import CryptoKit
class Verification {
    private var contractFile:URL
    init(contractFile: URL) {
        self.contractFile = contractFile
    }
    func verificate() {
        if let pdf = PDFDocument(url: self.contractFile) {
            let pageCount = pdf.pageCount
            let documentContent = NSMutableAttributedString()
            
            for i in 0 ..< pageCount {
                guard let page = pdf.page(at: i) else { continue }
                guard let pageContent = page.attributedString else { continue }
                documentContent.append(pageContent)
            }
            let text = documentContent.string
            
            // text 데이터 기반으로 해시값 추출
            let data = text.data(using: .utf8)
            let sha256 = SHA256.hash(data: data!)
            let shaData = sha256.compactMap{String(format: "%02x", $0)}.joined() // 16진법의 결과값으로 변환
            
            // 추출한 해시 값을 매개변수로 검증 API 호출
            // shaData를 기반으로 검증 API 호출
        }
    }
}
