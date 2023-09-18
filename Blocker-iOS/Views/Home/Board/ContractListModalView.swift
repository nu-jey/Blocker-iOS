//
//  ContractListModalView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/14.
//

import SwiftUI

struct ContractListModalView: View {
    @Binding var contractId:Int?
    @Binding var contractTitle:String?
    @Binding var isShowing:Bool
    @State private var curHeight:CGFloat = 400
    @State private var isDragging = false
    @StateObject var contractsViewModel:ContractsViewModel = ContractsViewModel()
    let minHeight:CGFloat = 400
    let maxHeight:CGFloat = 700
    
    let startOpacity:Double = 0.4
    let endOpacity:Double = 0.8
    var percentage:Double {
        let res = Double((curHeight - minHeight) / (maxHeight-minHeight))
        return max(0, min(1, res))
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(startOpacity + (endOpacity - startOpacity) * percentage)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                contentView
                    .transition(.move(edge: .bottom ))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(isDragging ? nil : .easeInOut(duration: 0.45))
        .onAppear {
            contractsViewModel.getContractListResponseData(.notSigned)
        }
    }

    var contentView: some View {
        return VStack {
            ZStack {
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.0001))
            .gesture(dragGesture)
            ZStack {
                VStack {
                    List(contractsViewModel.notSigendContractListResponseData, id: \.contractId) { contarct in
                        Button(contarct.title) {
                            print(contarct.title)
                            self.contractId = contarct.contractId
                            self.contractTitle = contarct.title
                            isShowing = false
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                Rectangle()
                    .frame(height: curHeight / 2)
            }
            .foregroundColor(.white)
        )
        
    }
    
    @State private var prevDrageTranslation = CGSize.zero
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    isDragging = true
                }
                let dragAmount = val.translation.height - prevDrageTranslation.height
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                prevDrageTranslation = val.translation
                
            }
            .onEnded { val in
                prevDrageTranslation = .zero
                isDragging = false
                if curHeight > maxHeight {
                    curHeight = maxHeight
                } else if curHeight < minHeight {
                    // curHeight = minHeight
                    isShowing = false
                }
            }
    }
}

struct ContractListModalView_Previews: PreviewProvider {
    static var previews: some View {
        //ContractListModalView(isShowing: .constant(false))
        WritePostView()
    }
}
