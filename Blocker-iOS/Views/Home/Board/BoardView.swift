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
        VStack(spacing: 0) {
            AsyncImageView(iamgeURL: boardItem.representImage)
            VStack(alignment: .leading) {
                VStack {
                    Text(boardItem.title)
                        .font(.title)
                    Text(boardItem.content)
                        .font(.body)
                }
                .padding([.leading, .top], 20)
                .foregroundColor(Color("textColor"))
                HStack {
                    Image(systemName: "person.circle")
                    Text(boardItem.name)
                    Spacer()
                    Image(systemName: "eye.fill")
                    Text("\(boardItem.view)")
                    Image(systemName: "heart.fill")
                    Text("\(boardItem.bookmarkCount)")
                }
                .padding([.leading, .trailing, .bottom], 20)
                .foregroundColor(Color("textColor"))
            }
            .frame(height: 100)
            .background(Color("subBackgroundColor"))
            .cornerRadius(20, corners: [.bottomRight, .bottomLeft])
        }
        .padding()
    }
}

struct AsyncImageView:View {
    @State var iamgeURL:String
    var body: some View {
        AsyncImage(url: URL(string:iamgeURL))
        { phase in
            if let image = phase.image {
                image // Displays the loaded image.
                    .resizable()
                    .frame(height: 100)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
            } else if phase.error != nil {
                Color.white // Acts as a placeholder.
            } else {
                Image(systemName: "photo.fill")
                    .frame(height: 100)
            }
        }
    }
}
struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        // BoardView()
        BoardCellView(boardItem: BoardResponseData(boardId: 1, title: "Title", name: "123", content: "123", representImage: "123", view: 1, bookmarkCount: 1, createdAt: "1", modifiedAt: "1"))
    }
}
