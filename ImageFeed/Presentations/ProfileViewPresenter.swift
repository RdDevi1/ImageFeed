//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 14.02.2023.
//

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logoutAlert() -> UIAlertController
}


final class ProfilePresenter {
    
    weak var view: ProfileViewControllerProtocol?
    private var profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.view?.updateProfileDetails(profile: profile)
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                
            case .failure(let error):
                print(error)
                self.view?.showAlert(title: "Что-то пошло не так(", message: "Не удалось загрузить информацию") { [weak self] _ in
                    self?.fetchProfile(token: token)
                }
            }
        }
    }
    
    private func logout() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        oAuth2TokenStorage.clean()
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    
}

// MARK: - ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    
    func logoutAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        let confirmAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            self.logout()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        return alert
    }
    
    func viewDidLoad() {
        guard let token = oAuth2TokenStorage.bearerToken else { return }
        fetchProfile(token: token)
    }
}
