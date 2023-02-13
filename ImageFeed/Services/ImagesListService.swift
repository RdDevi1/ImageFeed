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
    
    
    //MARK: - Singleton
    static let shared = ImagesListService()
    private init() {}
    
    //MARK: - Methods
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let nextPage: Int
        if let lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 1
        }
        
        let request = makeRequestPhoto(for: nextPage)
        
        let task = urlSession.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            
            switch result {
            case .success(let photoResult):
                photoResult.forEach { photoResult in
                    let photo =  Photo(id: photoResult.id,
                                       size: CGSize(width: photoResult.width, height: photoResult.height),
                                       createdAt: Date.convertStringToDate(photoResult.createdAt ?? ""),
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
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        let request = makeRequestForLike(for: photoId, isLike: isLike)
        
        let task = urlSession.objectTask(for: request) { (result: Result<LikeResult, Error>) in
            switch result {
            case .success:
                // Поиск индекса элемента
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    // Текущий элемент
                    let photo = self.photos[index]
                    // Копия элемента с инвертированным значением isLiked.
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    // Заменяем элемент в массиве.
                    self.photos[index] = newPhoto
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeRequestPhoto(for nextPage: Int) -> URLRequest {
        guard let token = oAuth2TokenStorage.bearerToken else { fatalError("No token provided") }
        
        guard var urlComponents = URLComponents(string: Constants.photoURL) else { fatalError() }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value:  "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    private func makeRequestForLike(for photoId: String, isLike: Bool) -> URLRequest {
        guard let token = oAuth2TokenStorage.bearerToken else { fatalError("No token provided") }
        guard var urlComponents = URLComponents(url: Constants.defaultBaseURL, resolvingAgainstBaseURL: true) else { fatalError() }
        urlComponents.path = "/photos/\(photoId)/like"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "DELETE" : "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}

