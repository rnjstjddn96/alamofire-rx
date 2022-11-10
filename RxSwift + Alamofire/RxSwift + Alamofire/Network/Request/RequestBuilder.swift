//
//  RequestBuilder.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/10.
//

import Foundation
import Alamofire

struct Multipart {
    var data: [String: Data?]
    var fileName: String?
    var mimeType: String?
}

protocol RequestBuilder {
    typealias Parameters = [String: Any]
    typealias Multiparts = [Multipart]
    var url: URL { get }
    var authentication: Bool { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
    var multipartData: Multiparts? { get }
    var method: HTTPMethod { get }
    var path: String { get }
}
