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
    func getImage(forIndexPath indexPath: IndexPath, forViewType viewType: CarouselViewType, forCarouselView carouselView: CarouselView)
    
    func titleButtonAction(viewType: CarouselViewType)
}

final class HomePresenter: HomePresenterProtocol {
    var router: HomeRouterProtocol!
    var interactor: HomeInteractorProtocol!
    unowned var view: HomeViewProtocol!
    
    // MARK: - GetData
    
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
            } catch {
                let message = ErrorProcessing.shared.getMessageFrom(error: error)
                view.showErrorAlert(with: Strings.AlertController.Title.error, message: message + " TodayView.")
            }
        }
    }
    
    private func getDataForUpdatesView(carouselView: CarouselView) {
        Task {
            do {
                let data = try await interactor.requestDataForUpdatesView()
                view.update(data: data, inCarouselView: carouselView)
            } catch {
                let message = ErrorProcessing.shared.getMessageFrom(error: error)
                view.showErrorAlert(with: Strings.AlertController.Title.error, message: message + " UpdatesView.")
            }
        }
    }
    
    func getImage(forIndexPath indexPath: IndexPath, forViewType viewType: CarouselViewType, forCarouselView carouselView: CarouselView) {
        Task {
            do {
                guard let imageData = try await interactor.requestImageData(forIndex: indexPath.row, forViewType: viewType) else {
                    return
                }
                view.update(imageData: imageData, for: indexPath, inCarouselView: carouselView)
            } catch {
                let message = ErrorProcessing.shared.getMessageFrom(error: error)
                view.showErrorAlert(with: Strings.AlertController.Title.imageLoadingError, message: message)
            }
        }
    }
    
    // MARK: - TitleButtonAction
    
    func titleButtonAction(viewType: CarouselViewType) {
        switch viewType {
            case .todayCarouselView:
                router.showScheduleView()
            case .updatesCarouselView:
                let getTitleModel = interactor.getData(forViewType: viewType)
                router.showUpdatesView(with: getTitleModel)
        }
    }
    
}
