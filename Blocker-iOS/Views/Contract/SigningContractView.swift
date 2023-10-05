//
//  SigningContractView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/08.
//

import SwiftUI

struct SigningContractView: View {
    @State var contractId:Int
    @State var title:String = "title"
    @State var content:String = "content"
    @State var writer:String = "writer"
    @State var contractors:[String] = ["contractor1", "contractor2", "contractor3", "contractor4" ]
    @StateObject var signingContractViewModel:SigningContractViewModel = SigningContractViewModel()
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            Divider()
            Spacer()
            Text(content)
                .font(.body)
            Spacer()
            Divider()
            //ContractorsSignView()
            Divider()
            HStack {
                Button("Sign") {
                    // 전자 서명
                    signingContractViewModel.signOnContract(contractId)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
                Button("Cancel") {
                    // 계약 취소
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
            }
            .padding()
            .frame(height: 100)
        }
    }

}
struct ContractorsSignView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                VStack {
                    Image(uiImage: getSavedImage(named:"signature.png")!)
                        .resizable()
                        .frame(width: 150, height: 50)
                        .cornerRadius(10)
                    Text("contarctor1")
                        .foregroundColor(Color("textColor"))
                }
                VStack {
                    Image(uiImage: getSavedImage(named:"signature.png")!)
                        .resizable()
                        .frame(width: 150, height: 50)
                        .cornerRadius(10)
                    Text("contarctor1")
                        .foregroundColor(Color("textColor"))
                }
                VStack {
                    Image(uiImage: getSavedImage(named:"signature.png")!)
                        .resizable()
                        .frame(width: 150, height: 50)
                        .cornerRadius(10)
                    Text("contarctor1")
                        .foregroundColor(Color("textColor"))
                }
                VStack {
                    Image(uiImage: getSavedImage(named:"signature.png")!)
                        .resizable()
                        .frame(width: 150, height: 50)
                        .cornerRadius(10)
                    Text("contarctor1")
                        .foregroundColor(Color("textColor"))
                }
            }
        }
    }
    func getSavedImage(named: String) -> UIImage? {
      if let dir: URL
        = try? FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false) {
        let path: String
          = URL(fileURLWithPath: dir.absoluteString)
              .appendingPathComponent(named).path
        let image: UIImage? = UIImage(contentsOfFile: path)
        
        return image
      }
      return nil
    }
}
struct SigningContractView_Previews: PreviewProvider {
    static var previews: some View {
        SigningContractView(contractId: 0)
    }
}
