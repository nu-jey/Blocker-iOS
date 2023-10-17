//
//  NotSignedContractView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/08.
//

import SwiftUI
struct NotSignedContractView: View {
    @StateObject var  notSignedContractViewModel:NotSignedContractViewModel = NotSignedContractViewModel()
    @State var contractId:Int
    @State var contractorsModalControl:Bool = false
    @State var showingAlert:Bool = true
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
                    notSignedContractViewModel.deleteNotSignedContract(contractId)
                }) {
                    Label("Delete", systemImage: "trash.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Title"), message: Text("Message"),
                  dismissButton: .default(Text("Default")))
        }
    }
}

struct ProceedContractView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var keyword:String = ""
    @State var searchData:[UserResponseData] = []
    @State var partnerData:[UserResponseData] = []
    @State var contractors:[UserResponseData] = [BlockerServer.shared.getOwnData()]
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
                        searchData = proceedContractViewModel.contrators ?? []
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
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(contractors ?? [], id: \.email) { data in
                                ContractorCell(data: data, contractors: $contractors)
                            }
                        }
                    }
                    Button(action: {
                        proceedContractViewModel.proceedContract(contractId, contractors.map { $0.email })
                    }) {
                        ZStack {
                            Capsule()
                                .frame(width: 200, height: 50)
                                .foregroundColor(Color("signatureColor1"))
                            HStack {
                                Image(systemName: "pencil.and.outline")
                                Text("Proceed contract")
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                    }
                }
            }
            Divider()
            VStack {
                // 검색 결과 리스트 -> 프사, 이름, 이메일 순차적 표시 -> 추가 뷰 구성 필요
                ForEach(proceedContractViewModel.contrators ?? [], id: \.email) { data in
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
    @State var data:UserResponseData
    @Binding var contractors:[UserResponseData]
    var body: some View {
        Button(action: {
            contractors.append(data)
        }) {
            HStack(spacing: 10) {
                ZStack {
                    Image(systemName: "person.fill")
                    AsyncImage(url: URL(string:data.picture)) { phase in
                        if let image = phase.image { image // Displays the loaded image.
                            .resizable()
                            .frame(width: 75, height: 75)
                            .cornerRadius(20, corners: [.allCorners])
                        } else {
                            Image("defaultImage")
                                .resizable()
                                .frame(width: 75, height: 75)
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text(data.name)
                    Text(data.email)
                }
                .foregroundColor(Color("textColor"))
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}


struct ContractorCell:View {
    @State var data:UserResponseData
    @Binding var contractors:[UserResponseData]
    let tempLabel:UILabel = UILabel()
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Capsule()
                .frame(height: 30)
                .foregroundColor(.blue)
            HStack {
                Text(data.name)
                Button(action: {
                    contractors.remove(at: contractors.firstIndex(where:{ $0 == data })!)
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
        .onAppear {
            tempLabel.text = data.name
        }
    }
}

struct NotSignedContract_Previews: PreviewProvider {
    static var previews: some View {
        NotSignedContractView(contractId: 1)
        //ProceedContractView(contractId: .constant(1))
    }
}
