//
//  HomeModelInput.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

protocol HomeModelInput: ImageModel {
    var isDataTaskLoading: Bool { get }
    func requestData()
    func getRawData(row: Int) -> Any?
    func getRawData() -> [Any]
}
