//
//  BoardView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/02.
//

import SwiftUI

struct BoardView: View {
    private let values:[boardData] = [boardData(title: "123"), boardData(title: "456"), boardData(title: "789"), boardData(title: "789"), boardData(title: "789")]
    var body: some View {
        VStack {
            ForEach(values){ item in
                NavigationLink(destination: PostView()) {
                    BoardCellView(title: item.title)
                }
            }
        }
    }
}
struct boardData: Identifiable {
    let id = UUID()
    let title: String
}

struct BoardCellView: View {
    @State var title: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.blue)
                .frame(height: 100)
                .padding()
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(Color("textColor"))
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
