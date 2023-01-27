//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 27.01.2023.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Properties
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZ"
        return formatter
    }()
    
    
    //MARK: - Singleton
    static let shared = ImagesListService()
    private init() {}
    
    //MARK: - Methods
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage ?? 0 + 1
        let request = makeRequest(for: nextPage)
        
        let task = urlSession.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            
            switch result {
            case .success(let photoResult):
                photoResult.forEach { photoResult in
                    let photo =  Photo(id: photoResult.id,
                                       size: CGSize(width: photoResult.width, height: photoResult.height),
                                       createdAt: self.dateFormatter.date(from: photoResult.createdAt),
                                       welcomeDescription: photoResult.description,
                                       thumbImageURL: photoResult.urls.thumb,
                                       largeImageURL: photoResult.urls.full,
                                       isLiked: photoResult.isLiked
                    )
                    
                    self.photos.append(photo)
                }
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": self.photos]
                )
                print("SUCCESS--------------------> photoResult is here")
                self.task = nil
                self.lastLoadedPage = nextPage
                
            case .failure(let error):
                print(error)
            }
            
        }
        self.task = task
        task.resume()
    }
    
    
    private func makeRequest(for nextPage: Int) -> URLRequest {
        guard let token = oAuth2TokenStorage.bearerToken else { fatalError("No token provided") }
        
        guard var urlComponents = URLComponents(string: photoURL) else { fatalError() }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value:  "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}