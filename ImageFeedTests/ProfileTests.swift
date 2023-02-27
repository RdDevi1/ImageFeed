//
//  ProfileTests.swift
//  ProfileTests
//
//  Created by Vitaly Anpilov on 27.02.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}

final class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    
    var viewDidLoadCalled = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logoutAlert() -> UIAlertController {
        UIAlertController()
    }
}
