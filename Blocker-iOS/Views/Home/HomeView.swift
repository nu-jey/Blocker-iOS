//
//  HomeView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/02.
//

import SwiftUI

struct HomeView: View {
    @Binding var sideMenuControl: Bool
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            ScrollView {
                ImageSliderView()
                    .frame(width: constantData.width, height: constantData.width*0.6525)
                Divider()
                BoardView()
            }
            VStack {
                NavigationLink(destination: WritePostView()) {
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

struct ImageSliderView: View {
    let imageSource = ["banner1", "banner2", "banner3", "banner4"]
    var body: some View {
        VStack {
            TabView {
                ForEach(0..<3) { i in
                    Image("\(imageSource[i])").resizable()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .onAppear {
            self.toolbar(.hidden, for: .tabBar)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(sideMenuControl: .constant(false))
    }
}
