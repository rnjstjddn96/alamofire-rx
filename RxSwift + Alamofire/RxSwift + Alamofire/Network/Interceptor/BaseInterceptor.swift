//
//  BaseInterceptor.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/10.
//

import Foundation
import Alamofire

struct TokenCredential: AuthenticationCredential {
    var requiresRefresh: Bool { false }
    
    let accessToken: String
    let refreshToken: String
}

class TokenAuthenticator: Authenticator {
    typealias Credential = TokenCredential
    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }
    
    func refresh(_ credential: Credential, for session: Alamofire.Session, completion: @escaping (Result<TokenCredential, Error>) -> Void) {
        // refresh 요청
    }
    
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        // 인증이 필요한 API요청 유무
        return true
    }
}


