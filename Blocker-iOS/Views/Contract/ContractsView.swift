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
            ContractListView(contractType: "미체결", selectedContractTab: $selectedContractTab)
                .tag(0)
                .tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Folder")
                    }
                }
            ContractListView(contractType: "체결중", selectedContractTab: $selectedContractTab)
                .tag(1)
                .tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Folder")
                    }
                }
            ContractListView(contractType: "체결", selectedContractTab: $selectedContractTab)
                .tag(2)
                .tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Folder")
                    }
                }
        }
        .accentColor(Color("signatureColor1"))
        .padding(.bottom, 20)
    }
}

struct ContractListView: View {
    @State var contractType: String
    @Binding var selectedContractTab: Int
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            ScrollView {
                if selectedContractTab == 0 {
                    let data: [ContractData] = [
                        ContractData(title: "123"),
                        ContractData(title: "234"),
                        ContractData(title: "345"),
                        ContractData(title: "456"),
                    ]
                    ForEach(data) { item in
                        NavigationLink(destination: ContractView()) {
                            NotSignedContractCell(title: item.title)
                        }
                    }
                } else if selectedContractTab == 1 {
                    
                    let data: [ContractData] = [
                        ContractData(title: "123"),
                        ContractData(title: "234"),
                        ContractData(title: "345"),
                        ContractData(title: "456"),
                    ]
                    ForEach(data) { item in
                        NavigationLink(destination: ContractView()) {
                            SigningContractCell(title: item.title)
                        }
                    }
                } else {
                    
                    let data: [ContractData] = [
                        ContractData(title: "123"),
                        ContractData(title: "234"),
                        ContractData(title: "345"),
                        ContractData(title: "456"),
                    ]
                    ForEach(data) { item in
                        NavigationLink(destination: ContractView()) {
                            SignedContractCell(title: item.title)
                        }
                    }
                }
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

