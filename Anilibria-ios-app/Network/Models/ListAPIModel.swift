//
//  ListAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.01.2024.
//

import Foundation

/// Возвращается в запросах:
/// title/updates, title/changes, title/search, user/favorites
struct ListAPIModel<T: Decodable>: Decodable {
    let list: [T]
    let pagination: ListPagination
}

struct ListPagination: Decodable {
    let pages: Int
    let currentPage: Int
    let itemsPerPage: Int
    let totalItems: Int
    
    static func initialData() -> ListPagination {
        ListPagination(pages: -1, currentPage: 0, itemsPerPage: -1, totalItems: -1)
    }
    
    func areThereMorePages() -> Bool {
        currentPage < pages
    }
}
