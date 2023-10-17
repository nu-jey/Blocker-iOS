//
//  ContractsView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/02.
//

import SwiftUI

struct ContractsView: View {
    @Binding var sideMenuControl: Bool
    @State var selectedContractTab: Int = 0
    var body: some View {
        TabView(selection: $selectedContractTab) {
            ContractListView(contractType: .notSigned, selectedContractTab: $selectedContractTab)
                .tag(0)
                .tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Not Signed")
                    }
                }
            ContractListView(contractType: .signing, selectedContractTab: $selectedContractTab)
                .tag(1)
                .tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Signing")
                    }
                }
            ContractListView(contractType: .signed, selectedContractTab: $selectedContractTab)
                .tag(2)
                .tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Signed")
                    }
                }
        }
        .accentColor(Color("signatureColor1"))
        .padding(.bottom, 20)
    }
}

struct ContractListView: View {
    @State var contractType:ContractType
    @Binding var selectedContractTab: Int
    @StateObject var contractsViewModel:ContractsViewModel = ContractsViewModel()
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            ScrollView {
                if selectedContractTab == 0 {
                    ForEach(contractsViewModel.notSigendContractListResponseData, id: \.title) { item in
                        NavigationLink(destination: NotSignedContractView(contractId: item.contractId)) {
                            NotSignedContractCell(title: item.title)
                        }
                    }
                } else if selectedContractTab == 1 {
                    ForEach(contractsViewModel.signingContractListResponseData, id: \.title) { item in
                        NavigationLink(destination: SigningContractView(contractId: item.contractId)) {
                            SigningContractCell(title: item.title)
                        }
                    }
                } else {
                    ForEach(contractsViewModel.signedContractListResponseData, id: \.title) { item in
                        NavigationLink(destination: SignedContractView(contractId: item.contractId)) {
                            SignedContractCell(title: item.title)
                        }
                    }
                }
            }
            .onAppear {
                contractsViewModel.getContractListResponseData(contractType)
                print(contractType)
            }
            if selectedContractTab == 0 {
                VStack {
                    NavigationLink(destination: WriteContractView()) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("signatureColor1"))
                    }
                    .padding()
                }
            }
        }
    }
}
struct ContractData: Identifiable {
    let id = UUID()
    let title: String
}

struct NotSignedContractCell: View {
    @State var title:String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.blue)
                .frame(height: 50)
                .padding()
            Text(title)
        }
    }
}

struct SigningContractCell: View {
    @State var title:String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.blue)
                .frame(height: 100)
                .padding()
            Text(title)
        }
    }
}

struct SignedContractCell: View {
    @State var title:String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.blue)
                .frame(height: 50)
                .padding()
            Text(title)
        }
    }
}

struct ContractsView_Previews: PreviewProvider {
    static var previews: some View {
        ContractsView(sideMenuControl: .constant(true))
    }
}

