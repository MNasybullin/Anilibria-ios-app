//
//  AnimePosterModelOutput.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import UIKit

protocol AnimePosterModelOutput: AnyObject {
    func updateImage(for item: AnimePosterItem, image: UIImage, indexPath: IndexPath)
    func failedRequestImage(error: Error)
}
