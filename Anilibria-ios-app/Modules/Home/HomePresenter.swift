//
//  HomePresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var router: HomeRouterProtocol! { get set }
    var interactor: HomeInteractorProtocol! { get set }
    var view: HomeViewProtocol! { get set }
    
    func getDataForTodayView()
    func getDataForUpdatesView()
    func getImageFromData(_ data: [GetTitleModel]?, index: Int, identifier: CarouselView)
    
    func titleButtonAction()
}

final class HomePresenter: HomePresenterProtocol {
    
    var router: HomeRouterProtocol!
    var interactor: HomeInteractorProtocol!
    unowned var view: HomeViewProtocol!
    
    func getDataForTodayView() {
        // Узнаем какой сегодня день
        let date = Date()
        var weekday = Calendar.current.component(.weekday, from: date)
        // Текущий день по enum DaysOfTheWeek (0 - Понедельник)
        weekday -= 2
        weekday = weekday < 0 ? 6 : weekday
        let currentDay = DaysOfTheWeek(rawValue: weekday)
        Task {
            do {
                let data = try await interactor.requestDataForTodayView()
                data.forEach { model in
                    if model.day == currentDay {
                        view.updateDataInTodayView(withData: model.list)
                    }
                }
            } catch let error as MyNetworkError {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.error, message: error.description)
            } catch {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.error, message: error.localizedDescription)
            }
        }
    }
    
    func getDataForUpdatesView() {
//        interactor.requestDataForUpdatesView()
    }
    
    func getImageFromData(_ data: [GetTitleModel]?, index: Int, identifier: CarouselView) {
        guard let data = data else {
            return
        }
        
        Task {
            do {
                let imageData = try await interactor.requestImageFromData(withURLString: data[index].posters.original.url)
                var newData = data
                newData[index].posters.original.image = imageData
                newData[index].posters.original.loadingImage = false
                view.update(data: newData, inView: identifier)
            } catch let error as MyNetworkError {
                let errorMessage = error
                view.showErrorAlert(withTitle: Strings.AlertController.Title.imageLoadingError, message: error.description)
            } catch {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.imageLoadingError, message: error.localizedDescription)
            }
        }
    }
    
    func titleButtonAction() {
        // взять данные и обработать нажатие
    }
    
}
