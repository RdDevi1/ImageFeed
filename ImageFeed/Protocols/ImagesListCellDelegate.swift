//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 26.09.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
