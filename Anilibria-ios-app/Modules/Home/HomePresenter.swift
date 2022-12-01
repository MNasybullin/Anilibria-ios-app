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
    
    func getDataFor(carouselView: CarouselView, viewType: CarouselViewType)
    func getImage(forIndex index: Int, forViewType viewType: CarouselViewType, forCarouselView carouselView: CarouselView)
    
    func titleButtonAction()
}

final class HomePresenter: HomePresenterProtocol {
    var router: HomeRouterProtocol!
    var interactor: HomeInteractorProtocol!
    unowned var view: HomeViewProtocol!
    
    func getDataFor(carouselView: CarouselView, viewType: CarouselViewType) {
        switch viewType {
            case .todayCarouselView:
                getDataForTodayView(carouselView: carouselView)
            case .updatesCarouselView:
                getDataForUpdatesView(carouselView: carouselView)
        }
    }
    
    private func getDataForTodayView(carouselView: CarouselView) {
        let currentDay = DaysOfTheWeek.currentDayOfTheWeek()
        Task {
            do {
                let data = try await interactor.requestDataForTodayView(withDayOfTheWeek: currentDay)
                view.update(data: data, inCarouselView: carouselView)
            } catch let error as MyNetworkError {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.error, message: error.description)
            } catch let error as MyInternalError {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.error, message: error.description)
            } catch {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.error, message: error.localizedDescription)
            }
        }
    }
    
    private func getDataForUpdatesView(carouselView: CarouselView) {
//        interactor.requestDataForUpdatesView()
    }
    
    func getImage(forIndex index: Int, forViewType viewType: CarouselViewType, forCarouselView carouselView: CarouselView) {
        Task {
            do {
                guard let data = try await interactor.requestImageFromData(forIndex: index, forViewType: viewType) else {
                    return
                }
                view.update(data: data, inCarouselView: carouselView)
            } catch let error as MyNetworkError {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.imageLoadingError, message: error.description)
            } catch let error as MyInternalError {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.error, message: error.description)
            } catch {
                view.showErrorAlert(withTitle: Strings.AlertController.Title.imageLoadingError, message: error.localizedDescription)
            }
        }
    }
    
    func titleButtonAction() {
        // взять данные и обработать нажатие
    }
    
}
