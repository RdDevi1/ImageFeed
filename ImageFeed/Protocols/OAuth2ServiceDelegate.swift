//
//  OAuth2ServiceDelegate.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 26.09.2023.
//

import Foundation

protocol OAuth2ServiceDelegate {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void )
}
