//
//  Verification.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/12.
//

import Foundation
import PDFKit
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
            print(documentContent.string) // text 데이터
            
            // text 데이터 기반으로 해시값 추출
            
            // 추출한 해시 값을 매개변수로 검증 API 호출 
        }
    }
}
