//
//  ViewPreview.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.08.2022.
//

// https://medium.com/swlh/how-to-use-live-previews-in-uikit-204f028df3a9

import UIKit
import SwiftUI

struct ViewPreview: UIViewRepresentable {
    let viewBuilder: () -> UIView

    init(_ viewBuilder: @escaping () -> UIView) {
        self.viewBuilder = viewBuilder
    }

    func makeUIView(context: Context) -> some UIView {
        viewBuilder()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Not needed
    }
}

/*
 
 #if DEBUG
 
 // MARK: - Live Preview In UIKit
 import SwiftUI
 struct View_Previews: PreviewProvider {
     static var previews: some View {
         ViewPreview {
             // View()
         }
         .previewDevice("iPhone 12")
     }
 }
 
 #endif
 
*/
