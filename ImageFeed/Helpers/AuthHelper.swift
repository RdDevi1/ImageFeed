//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 13.02.2023.
//

import Foundation

class AuthHelper: AuthHelperProtocol {
    var authRequest: URLRequest {
        URLRequest(url: self.authURL())
    }
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents.url!
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
}
