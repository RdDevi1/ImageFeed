//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 13.02.2023.
//

import Foundation


final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    //MARK: - Lifecycle
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        let request = authHelper.authRequest
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    //MARK: - Methods
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
}
