//
//  HomeModelInput.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

protocol HomeModelInput: AnyObject {
    var isDataTaskLoading: Bool { get }
    func requestImage(from imageUrlString: String, indexPath: IndexPath)
    func requestData()
    func getRawData(row: Int) -> TitleAPIModel?
}
