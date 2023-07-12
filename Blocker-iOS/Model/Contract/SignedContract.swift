//
//  SignedContract.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/12.
//

import Foundation
import UIKit

class SignedContract {
    private var title:String
    private var content:String
    private var writer:String
    private var contractors:[String]
    private var signatures:[UIImage]
    
    init(title: String, content: String, writer: String, contractors: [String], signatures: [UIImage]) {
        self.title = title
        self.content = content
        self.writer = writer
        self.contractors = contractors
        self.signatures = signatures
    }
    func convertPDF() {
        
        // 1. 출력 양식 설정
        let html = "<b>Hello <i>World!</i></b>" // html로 계약서 형식 지정
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. 출력 양식 할당
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. 출력 페이지 양식 설정 및 할당
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")

        // 4. 작성한 데이터 기반으로 pdf 파일 생성
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage();
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }

        UIGraphicsEndPDFContext();

        // 5. pdf 파일 저장 경로 설정 및 저장
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("output").appendingPathExtension("pdf")
            else { fatalError("Destination URL not created") }

        pdfData.write(to: outputURL, atomically: true)
        
    }
    func cancelContract() {
        
    }
    func editContract() {
        
    }
}
