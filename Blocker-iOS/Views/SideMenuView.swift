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
    var body: some View {
           VStack(alignment: .leading){
               Button {
                   selectedMenuTab = 0
                   sideMenuControl.toggle()
               }
               label: {
                   HStack{
                       Image(systemName: "b.circle")
                           .foregroundColor(.gray)
                           .imageScale(.large)
                       Text("Home")
                           .foregroundColor(Color("textColor"))
                           .font(.headline)
                   }
                   .padding(.top, 100)
               }
               Button {
                   selectedMenuTab = 1
                   sideMenuControl.toggle()
               }
               label: {
                   HStack{
                       Image(systemName: "person")
                           .foregroundColor(.gray)
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
                           .foregroundColor(.gray)
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
                           .foregroundColor(.gray)
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
       }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(selectedMenuTab: .constant(0), sideMenuControl: .constant(false))
    }
}
