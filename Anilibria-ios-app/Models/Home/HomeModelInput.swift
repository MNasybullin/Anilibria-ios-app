//
//  HomeModelInput.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

protocol HomeModelInput: AnyObject {
    var isDataTaskLoading: Bool { get }
    func requestImage(from item: AnimePosterItem, indexPath: IndexPath)
    func requestData()
    func refreshData()
    func getRawData() -> [TitleAPIModel]
}
