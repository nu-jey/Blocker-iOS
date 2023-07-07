//
//  SearchPostView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/07.
//

import SwiftUI

struct SearchPostView: View {
    @State var searchKeyword:String = ""
    @State var searchData:[BoardData] = [BoardData(title: "123"), BoardData(title: "456")]
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            VStack {
                HStack {
                    TextField("Enter Keyword For Search", text: $searchKeyword)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        .onSubmit {
                            print("return 시 검색 수행되도록")
                        }
                        .focused($isFocused)
                        .onAppear {
                            // view가 로드되기전 검색창에 포커스를 줘서 키보드가 올라오도록
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isFocused = true
                            }
                        }
                }
                .padding()
                Divider()
                ScrollView {
                    // 검색 결과
                    VStack {
                        ForEach(searchData){ item in
                            NavigationLink(destination: PostView()) {
                                BoardCellView(title: item.title)
                            }
                        }
                    }
                }
            }
            
        }
    }
}

struct SearchPostView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPostView()
    }
}
