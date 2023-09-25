//
//  NotSignedContract.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/08.
//

import SwiftUI

struct NotSignedContract: View {
    @StateObject var  notSignedContractViewModel:NotSignedContractViewModel = NotSignedContractViewModel()
    @State var contractId:Int
    @State var contractorsModalControl:Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Text(notSignedContractViewModel.notSignedContractResponseData?.title ?? "")
                .font(.title)
            Divider()
            Spacer()
            Text(notSignedContractViewModel.notSignedContractResponseData?.content ?? "")
                .font(.body)
            Spacer()
            Divider()
            HStack {
                Button("Proceed") {
                    contractorsModalControl = true
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color("subBackgroundColor"))
                .cornerRadius(5)
                .fullScreenCover(isPresented: $contractorsModalControl) {
                    ProceedContractView(contractId: $contractId)
                }
            }
            .padding()
            .frame(height: 100)
        }
        .onAppear {
            self.notSignedContractViewModel.getNotSignedContract(contractId)
        }
        .toolbar {
            Menu {
                Button {
                    
                } label: {
                    Label("Edit", systemImage: "pencil.circle")
                }
                Button(action: {
                    dismiss()
                }) {
                    Label("Delete", systemImage: "trash.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
            }
        }
    }
}

struct ProceedContractView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var keyword:String = ""
    @State var searchData:[String] = ["123", "456", "789"]
    @State var partnerData:[String] = ["abc", "def", "ghi"]
    @State var contractors:[String] = []
    @Binding var contractId:Int
    @StateObject var proceedContractViewModel:ProceedContractViewModel = ProceedContractViewModel()
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                TextField("Search Id or name", text: $keyword)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                    .onSubmit {
                        proceedContractViewModel.searchUser(keyword)
                    }
                Button(action: {
                    // 파트너 리스트 불러오기
                    searchData = partnerData
                }) {
                    Image(systemName: "arrow.left.arrow.right")
                        .frame(width: 50, height: 50)
                }
                
            }
            Divider()
            VStack {
                if !contractors.isEmpty {
                    HStack {
                        // 계약참여자 등록 + 계약 진행 상호작용
                        ForEach(contractors, id: \.self) { data in
                            ContractorCell(name: data, contractors: $contractors)
                        }
                    }
                    Button(action: {
                        proceedContractViewModel.proceedContract(contractId, contractors)
                    }) {
                        ZStack {
                            Capsule()
                                .frame(width: 200, height: 50)
                                .foregroundColor(Color("signatureColor1"))
                            HStack {
                                Image(systemName: "pencil.and.outline")
                                Text("Proceed contract")
                            }
                        }
                    }
                }
            }
            Divider()
            VStack {
                // 검색 결과 리스트 -> 프사, 이름, 이메일 순차적 표시 -> 추가 뷰 구성 필요 
                ForEach(searchData, id: \.self) { data in
                    UserSearchCell(data: data, contractors: $contractors)
                }
            }
            Button("Back") {
                self.presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
    }
}

struct UserSearchCell: View {
    @State var data:String
    @Binding var contractors:[String]
    var name:String = "Oh Ye Jun"
    var email:String = "yp50777@naver.com"
    var body: some View {
        HStack {
            Button(action: {
                if !contractors.contains(data) {
                    contractors.append(data)
                }
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color("subBackgroundColor"))
                        .frame(width: 50, height: 50)
                    Image(systemName: "person.fill")
                }
                Text("\(name) (\(email))")
            }
        }
    }
}

struct ContractorCell:View {
    @State var name:String
    @Binding var contractors:[String]
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                Capsule()
                    .frame(width: 100, height: 30)
                    .foregroundColor(.blue)
                Text(name)
            }
            Button(action: {
                contractors.remove(at: contractors.firstIndex(of: name)!)
            }) {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct NotSignedContract_Previews: PreviewProvider {
    static var previews: some View {
        // NotSignedContract(contractId: 3)
        ProceedContractView(contractId: .constant(1))
    }
}
