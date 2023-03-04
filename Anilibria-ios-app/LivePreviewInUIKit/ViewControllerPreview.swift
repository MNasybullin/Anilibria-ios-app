//
//  ViewControllerPreview.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.08.2022.
//

// https://medium.com/swlh/how-to-use-live-previews-in-uikit-204f028df3a9

import UIKit
import SwiftUI

struct ViewControllerPreview: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Not needed
    }
}

/*
 
 #if DEBUG
 
 // MARK: - Live Preview In UIKit
 import SwiftUI
 struct ViewController_Previews: PreviewProvider {
     static var previews: some View {
         ViewControllerPreview {
             // ViewController()
         }
     }
 }
 
 #endif
 
 */
