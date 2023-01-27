//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Vitaly Anpilov on 27.01.2023.
//


@testable import ImageFeed
import XCTest

//final class ImagesListServiceTests: XCTestCase {
//    func testFetchPhotos() {
//        let service = ImagesListService.shared
//        
//        let expectation = self.expectation(description: "Wait for Notification")
//        NotificationCenter.default.addObserver(
//            forName: ImagesListService.didChangeNotification,
//            object: nil,
//            queue: .main) { _ in
//                expectation.fulfill()
//            }
//        
//        service.fetchPhotosNextPage()
//        wait(for: [expectation], timeout: 10)
//        
//        XCTAssertEqual(service.photos.count, 10)
//        service.fetchPhotosNextPage()
//        service.fetchPhotosNextPage()
//        
//    }
//}
