//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 14.02.2023.
//

import Foundation

final class ImagesListPresenter {
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
}

// MARK: - ImagesListPresenterProtocol

extension ImagesListPresenter: ImagesListPresenterProtocol {
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.view?.updateTableViewAnimated()
            }
        )
        imagesListService.fetchPhotosNextPage()
    }
    
}
