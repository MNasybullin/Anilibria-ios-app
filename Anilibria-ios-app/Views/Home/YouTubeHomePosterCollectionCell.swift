//
//  YouTubeHomePosterCollectionCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.12.2023.
//

import UIKit
import SkeletonView

final class YouTubeHomePosterCollectionCell: HomePosterCollectionViewCell {
    override var imageViewRatio: CGFloat {
        480 / 270
    }
    
    override func imageViewAdditionallyConfigure(_ imageView: UIImageView) {
        super.imageViewAdditionallyConfigure(imageView)
        imageView.contentMode = .scaleAspectFill
    }
}
