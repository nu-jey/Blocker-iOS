//
//  MainView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/01.
//

import SwiftUI

struct ContentView: View {
    @State var sideMenuControl = false
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.sideMenuControl = false
                    }
                }
            }
        return NavigationView {
            GeometryReader{ geometry in
                ZStack(alignment:.leading) {
                    MainView(sideMenuControl: self.$sideMenuControl)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .offset(x:self.sideMenuControl ? geometry.size.width/2 : 0)
                        .disabled(self.sideMenuControl ? true : false)
                    
                    if self.sideMenuControl {
                        SideMenuView()
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
        
        
    }
}

struct MainView: View {
    @Binding var sideMenuControl : Bool
    var body: some View {
        Text("Main View")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
