//
//  HomeModelOutput.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import UIKit

protocol HomeModelOutput: AnyObject {
    func refreshData(items: [AnimePosterItem], section: HomeView.Section)
    func updateData(items: [AnimePosterItem], section: HomeView.Section)
    func updateImage(for item: AnimePosterItem, image: UIImage)
    func failedRefreshData(error: Error)
}
