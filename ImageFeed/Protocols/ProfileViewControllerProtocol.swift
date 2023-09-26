//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 26.09.2023.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile?)
    func showAlert(title: String,
                   message: String,
                   action: ((UIAlertAction) -> (Void))?
    )
}
