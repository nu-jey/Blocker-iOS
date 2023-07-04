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
            ContractListView(contractType: "미체결")
                .tag(0)
                .toolbar(.visible, for: .tabBar)
            ContractListView(contractType: "체결중")
                .tag(1)
                .toolbar(.visible, for: .tabBar)
            ContractListView(contractType: "체결")
                .tag(2)
                .toolbar(.visible, for: .tabBar)
        }
    }
}

struct ContractListView: View {
    @State var contractType: String
    var body: some View {
        Text("\(contractType)")
    }
}

struct ContractsView_Previews: PreviewProvider {
    static var previews: some View {
        ContractsView(sideMenuControl: .constant(true))
    }
}
