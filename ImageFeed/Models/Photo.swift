//
//  Photo.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 27.01.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}


struct PhotoResult: Decodable {
    
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    var isLiked: Bool
    let description: String?
    let urls: UrlsResult
    
    struct UrlsResult: Decodable {
        let full: String
        let thumb: String
    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case isLiked = "liked_by_user"
        case id, width, height, description, urls
    }
}


struct LikeResult: Decodable {
    let photo: PhotoResult
}
