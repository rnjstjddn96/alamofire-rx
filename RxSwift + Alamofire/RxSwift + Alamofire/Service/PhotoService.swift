//
//  PhotoService.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/14.
//

import Foundation
import RxSwift

protocol PhotoServiceInterface {
    var service: NetworkService { get }
    func getPhotosLists() -> Observable<PhotoListDto>
}

class PhotoService: PhotoServiceInterface {
    var service = NetworkService()
    
    func getPhotosLists() -> Observable<PhotoListDto> {
        return service.requestPlain(APIs.PHOTOS)
    }
}
