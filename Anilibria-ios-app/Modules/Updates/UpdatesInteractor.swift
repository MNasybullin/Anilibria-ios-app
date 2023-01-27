//
//  UpdatesInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation

protocol UpdatesInteractorProtocol: AnyObject {
    var presenter: UpdatesPresenterProtocol! { get set }
    
    func requestUpdatesData() async throws -> [PostersListViewModel]
    func requestImageFromData(forSection section: Int, forIndex index: Int) async throws -> PostersListModel?
}

final class UpdatesInteractor: UpdatesInteractorProtocol {
    unowned var presenter: UpdatesPresenterProtocol!
    
    private var titleModel: [GetTitleModel]?
    private var postersListViewModel = [PostersListViewModel]()
    
    func requestUpdatesData() async throws -> [PostersListViewModel] {
        do {
            let data = try await QueryService.shared.getUpdates()
            titleModel = data
            // Converting [GetTitleModel] -> [PostersListViewModel]
            var list = [PostersListModel]()
            data.forEach { list.append(PostersListModel(title: $0.names.ru)) }
            postersListViewModel.append(PostersListViewModel(list: list))
            return postersListViewModel
        } catch {
            throw error
        }
    }
    
    func requestImageFromData(forSection section: Int, forIndex index: Int) async throws -> PostersListModel? {
        guard let imageURL = titleModel?[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let image = try await QueryService.shared.getImage(from: imageURL)
            postersListViewModel[section].list[index].image = image
            postersListViewModel[section].list[index].imageIsLoading = false
            return postersListViewModel[section].list[index]
        } catch {
            throw error
        }
    }
}
