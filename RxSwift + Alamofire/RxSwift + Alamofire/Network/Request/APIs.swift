//
//  APIs.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/10.
//

import Foundation
import Alamofire

enum APIs {
    case TODOS
    case PHOTOS
}

extension APIs: RequestBuilder {
    var url: URL {
        let url = URL(string: NetworkConfig.HOST_URL)!
        return url.appendingPathComponent(self.path)
    }
    
    var authentication: Bool {
        return false
    }
    
    var path: String {
        switch self {
        case .PHOTOS:
            return "photos"
        case .TODOS:
            return "todos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .TODOS:
            return .get
        case .PHOTOS:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        var headers = HTTPHeaders()
        return headers
    }
    
    
    var parameters: Parameters? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var multipartData: Multiparts? {
        return nil
    }
}
