//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 26.09.2023.
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
}
