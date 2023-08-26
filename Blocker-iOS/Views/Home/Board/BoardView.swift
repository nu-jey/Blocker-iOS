//
//  BoardView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/02.
//

import SwiftUI

struct BoardView: View {
    @StateObject var boardViewModel:BoardViewModel = BoardViewModel()
    var body: some View {
        VStack {
            ForEach(boardViewModel.boardResponseData, id: \.boardId){ item in
                NavigationLink(destination: PostView(boardId: item.boardId)) {
                    BoardCellView(boardItem: item)
                }
            }
        }.onAppear {
            boardViewModel.getBoardData(4, 0)
        }
    }
}


struct BoardCellView: View {
    @State var boardItem:BoardResponseData
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.blue)
                .frame(height: 100)
                .padding()
            VStack(alignment: .leading) {
                Text(boardItem.title)
                Text(boardItem.content)
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
