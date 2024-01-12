//
//  HomeModelOutput.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import UIKit

protocol HomeModelOutput: AnyObject {
    func updateData(items: [HomePosterItem], section: HomeView.Section)
    func failedRequestData(error: Error)
}
