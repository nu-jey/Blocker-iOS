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
        ImageSliderView()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.6525)
        Divider()
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
    }
}
