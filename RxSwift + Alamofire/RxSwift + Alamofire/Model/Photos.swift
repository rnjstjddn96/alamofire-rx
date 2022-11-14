//
//  Photos.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/14.
//

import Foundation

struct PhotoListDto: Decodable {
    var id: Int
    var albumId: Int?
    var title: String
    var imageUrl: String?
    var thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case albumId = "albumId"
        case title = "title"
        case imageUrl = "url"
        case thumbnailUrl = "thumbnailUrl"
        
    }
}
