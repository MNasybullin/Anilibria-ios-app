//
//  PosterItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.01.2024.
//

import UIKit

protocol PosterItem: Hashable {
    var name: String { get }
    var imageUrlString: String { get }
    var image: UIImage? { get set }
}
