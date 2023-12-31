//
//  MainView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/01.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @State var sideMenuControl = false
    @State var selectedMenuTab = 0
    @State var isCancel = false
    @State var selectedContractTab = 0
    @EnvironmentObject var laucnViewModel:LaunchViewModel
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.sideMenuControl = false
                    }
                }
            }
        switch laucnViewModel.state {
        case .signedOut: LaunchView(launchViewModel: laucnViewModel)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        case .signedIn: NavigationView {
                GeometryReader{ geometry in
                    ZStack(alignment:.leading) {
                        MainView(sideMenuControl: self.$sideMenuControl, selectedMenuTab: self.$selectedMenuTab, isCancel: self.$isCancel, selectedContractTab: $selectedContractTab)
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                            .offset(x:self.sideMenuControl ? geometry.size.width/2 : 0)
                            .disabled(self.sideMenuControl ? true : false)
                        
                        if self.sideMenuControl {
                            SideMenuView(selectedMenuTab: self.$selectedMenuTab, sideMenuControl: self.$sideMenuControl)
                                .frame(width:geometry.size.width/2)
                                .transition(.move(edge: .leading))
                        }
                    }
                    .gesture(drag)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        if !sideMenuControl {
                            Text("Blocker")
                                .font(.headline)
                                .foregroundColor(Color("textColor"))
                        }
                    }
                }
                .navigationBarItems(leading: (
                    HStack{
                        Button(action: {
                            withAnimation {
                                self.sideMenuControl.toggle()
                            }
                        })
                        {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }
                    }
                ))
            }
        case .signautreNeeded:
            SignView(launchViewModel: laucnViewModel)
        }
    }
}

struct MainView: View {
    @Binding var sideMenuControl : Bool
    @Binding var selectedMenuTab: Int
    @Binding var isCancel:Bool
    @Binding var selectedContractTab: Int
    var body: some View {
        TabView(selection: $selectedMenuTab) {
            HomeView(sideMenuControl: $sideMenuControl)
                .tag(0)
                .padding(.top, 20)
            MyPageView(sideMenuControl: $sideMenuControl)
                .tag(1)
                .padding(.top, 20)
            ContractsView(sideMenuControl: $sideMenuControl, selectedContractTab: $selectedContractTab)
                .tag(2)
                .padding(.top, 20)
            VerificationView(sideMenuControl: $sideMenuControl)
                .tag(3)
                .padding(.top, 20)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 100.00)
        .toolbar {
            if selectedMenuTab == 0 {
                NavigationLink(destination: SearchPostView()) {
                    Image(systemName: "magnifyingglass")
                }
            }
            if selectedMenuTab == 2 && selectedContractTab > 0 {
                Toggle(isOn: $isCancel) {
                    Text("파기")
                }
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
