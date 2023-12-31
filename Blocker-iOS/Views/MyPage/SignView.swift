//
//  SignView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/07/04.
//

import SwiftUI
import PencilKit

struct SignView: View {
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @StateObject var signViewModel = SignViewModel()
    @StateObject var launchViewModel:LaunchViewModel
    
    var body: some View {
        VStack {
            MyCanvas(canvasView: $canvasView)
                .frame(width: 300, height: 100)
            HStack(spacing: 10) {
                Button("Clear") {
                    canvasView.drawing = PKDrawing()
                }
                .frame(width: 140)
                .background(Color.red)
                Spacer()
                Button("Save") {
                    let res = saveSignatureImage()
                    if res {
                        print("전자 서명 저장 성공")
                        self.launchViewModel.state = .signedIn
                    } else {
                        print("전자 서명 저장 오류 발생")
                        self.launchViewModel.state = .signedOut
                    }
                }
                .frame(width: 140)
                .background(Color.yellow)
            }
            .frame(width: 300)
        }
        .padding()
        .background(Color("subBackgroundColor"))
        .cornerRadius(10)
    }
    
    func saveSignatureImage() -> Bool {
        let image = canvasView.drawing.image(from: CGRect(x: 0, y: 0, width: canvasView.frame.width, height: canvasView.frame.height), scale: 1.0)
        let res = signViewModel.updateSign(image)
        print(res.1, res.0)
        return res.0
    }
}
struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    let penColor = UIColor(named: "signatureColor2")!
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: penColor, width: 15)
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) { }
}

struct SignView_Previews: PreviewProvider {
    static var previews: some View {
        SignView(launchViewModel: LaunchViewModel())
    }
}
