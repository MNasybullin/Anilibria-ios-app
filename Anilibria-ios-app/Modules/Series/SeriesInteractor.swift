//
//  SeriesInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06/04/2023.
//

import Foundation

protocol SeriesInteractorProtocol: AnyObject {
	var presenter: SeriesPresenterProtocol! { get set }
}

final class SeriesInteractor: SeriesInteractorProtocol {
    unowned var presenter: SeriesPresenterProtocol!

}
