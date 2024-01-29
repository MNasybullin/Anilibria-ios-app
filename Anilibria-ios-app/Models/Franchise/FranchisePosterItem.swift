//
//  FranchisePosterItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.01.2024.
//

import UIKit

struct FranchisePosterItem: PosterItem {
    let name: String
    let imageUrlString: String
    var image: UIImage?
    let sectionName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(imageUrlString)
        hasher.combine(sectionName)
    }
    
    static func == (lhs: FranchisePosterItem, rhs: FranchisePosterItem) -> Bool {
        lhs.name == rhs.name && lhs.imageUrlString == rhs.imageUrlString && lhs.sectionName == rhs.sectionName
    }
}

extension FranchisePosterItem {
    init(fromTitleAPIModel model: TitleAPIModel, sectionName: String) {
        self.init(
            name: model.names.ru,
            imageUrlString: NetworkConstants.mirrorBaseImagesURL + model.posters.original.url,
            sectionName: sectionName
        )
    }
}
