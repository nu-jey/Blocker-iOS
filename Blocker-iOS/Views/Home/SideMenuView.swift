//
//  SideMenuView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/01.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var selectedMenuTab:Int
    @Binding var sideMenuControl:Bool
    @EnvironmentObject var laucnViewModel:LaunchViewModel
    var body: some View {
            VStack(alignment: .leading){
                HStack {
                    Button {
                        selectedMenuTab = 0
                        sideMenuControl.toggle()
                    }
                label: {
                    HStack{
                        Image(systemName: "b.circle")
                            .foregroundColor( (selectedMenuTab == 0) ? Color("signatureColor1"): Color.gray)
                            .imageScale(.large)
                        Text("Home")
                            .foregroundColor(Color("textColor"))
                            .font(.headline)
                    }
                    .padding(.top, 100)
                }
                }
                Button {
                    selectedMenuTab = 1
                    sideMenuControl.toggle()
                }
            label: {
                HStack{
                    Image(systemName: "person")
                        .foregroundColor( (selectedMenuTab == 1) ? Color("signatureColor1"): Color.gray)
                        .imageScale(.large)
                    Text("My Page")
                        .foregroundColor(Color("textColor"))
                        .font(.headline)
                }
            }
            .padding(.top, 30)
                Button {
                    selectedMenuTab = 2
                    sideMenuControl.toggle()
                }
            label: {
                HStack{
                    Image(systemName: "doc.plaintext")
                        .foregroundColor( (selectedMenuTab == 2) ? Color("signatureColor1"): Color.gray)
                        .imageScale(.large)
                    Text("Contracts")
                        .foregroundColor(Color("textColor"))
                        .font(.headline)
                }
                .padding(.top, 30)
            }
                
                Button {
                    selectedMenuTab = 3
                    sideMenuControl.toggle()
                }
            label: {
                HStack{
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor( (selectedMenuTab == 3) ? Color("signatureColor1"): Color.gray)
                        .imageScale(.large)
                    Text("Verification")
                        .foregroundColor(Color("textColor"))
                        .font(.headline)
                }
                .padding(.top, 30)
            }
                
                Button {
                    selectedMenuTab = 4
                    sideMenuControl.toggle()
                }
            label: {
                HStack{
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Messages")
                        .foregroundColor(Color("textColor"))
                        .font(.headline)
                }
                .padding(.top, 30)
            }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment:.leading)
            .background(Color("menuColor"))
            .edgesIgnoringSafeArea(.all)
            
            Button("Logout") {
                print("log out")
                laucnViewModel.signOut()
            }
            .padding(.top, 100)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(selectedMenuTab: .constant(0), sideMenuControl: .constant(false))
    }
}
