//
//  VerificationView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/02.
//

import SwiftUI

struct VerificationView: View {
    @Binding var sideMenuControl: Bool
    @State var fileName = "no file chosen"
    @State var openFile = false
    let height = UIScreen.main.bounds.height - 100.00
    var body: some View {
        VStack(spacing:0) {
            ZStack {
                Rectangle()
                    .fill(Color("backgroundColor"))
                VStack {
                    VerificationResultView()
                }
            }
            .frame(height: height/2)
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color("subBackgroundColor"))
                Button ("Verification") {
                    self.openFile.toggle()
                }
                .fileImporter(isPresented: $openFile, allowedContentTypes: constantData.allowedFileType,  allowsMultipleSelection: false, onCompletion: {(Result) in
                    do{
                        let fileURL = try Result.get()
                        // fileURL을 통해서 파일 접근 후 해쉬 값 추출 -> 서버로 전송
                        self.fileName = fileURL.first?.lastPathComponent ?? "file not available"
                        
                        let verification = Verification(contractFile: fileURL.first!)
                        verification.verificate()
                    }
                    catch{
                        print("error reading file \(error.localizedDescription)")
                    }
                })
            }
            .frame(height: height/2)
        }
        .ignoresSafeArea()
        
    }
}
struct VerificationResultView: View {
    var body: some View {
        VStack {
            Text("Verification Result ")
        }
    }
}
struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(sideMenuControl: .constant(true))
    }
}
