//
//  FeedView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.08.2022.
//

import UIKit

protocol FeedViewDelegate: AnyObject {
    
}

final class FeedView: UIView {
    weak var delegate: FeedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            FeedView()
        }
        .previewDevice("iPhone 12")
    }
}

#endif
