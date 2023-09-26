//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 26.09.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

