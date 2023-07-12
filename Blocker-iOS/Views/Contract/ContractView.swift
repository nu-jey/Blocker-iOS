//
//  ContractView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/05.
//

import SwiftUI

struct ContractView: View {
    @State var title:String = "title"
    @State var content:String = "content"
    @State var writer:String = "writer"
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding(.top, 20)
            HStack() {
                Spacer()
                Text(writer)
                    .font(.body)
                    .padding(.trailing, 20)
            }
            Divider()
            Spacer()
            Text(content)
                .font(.body)
            Spacer()
            Divider()
        }
    }
}

struct ContractView_Previews: PreviewProvider {
    static var previews: some View {
        ContractView()
    }
}
