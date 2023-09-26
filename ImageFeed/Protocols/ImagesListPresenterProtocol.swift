//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 26.09.2023.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
}
