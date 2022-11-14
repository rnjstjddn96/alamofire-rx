//
//  APIResult.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/14.
//

import Foundation
import RxSwift

class APIResult<T>: Decodable where T: Decodable {
    var code: Code
    var message: String?
    var value: T?
    
    init(
        code: Code = .SUCCESS,
        message: String? = nil,
        value: T?
    ) {
        self.code = code
        self.message = message
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
        case value = "data"
    }
}

