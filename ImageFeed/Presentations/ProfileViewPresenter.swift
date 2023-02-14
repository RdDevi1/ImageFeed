//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 14.02.2023.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    
}
