//
//  NetworkService.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/11.
//

import Foundation
import RxSwift
import Alamofire

final class NetworkService {
    func request<T>(
        _ requestBuilder: RequestBuilder,
        _ decoder: JSONDecoder = JSONDecoder()
    ) -> Observable<APIResult<T>> where T: Decodable {
        let authenticator = TokenAuthenticator()
        let credential = TokenCredential(
            accessToken: "set access token here",
            refreshToken: "set refresh token here"
        )
        
        let interceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credential
        )
                            
        return Observable.create { observer in
            let request = SessionManager.shared.getSession()?.request(
                requestBuilder.url,
                method: requestBuilder.method,
                parameters: requestBuilder.parameters,
                encoding: requestBuilder.parameterEncoding,
                headers: requestBuilder.headers,
                interceptor: interceptor
            )
            .validate(statusCode: Array(200..<300))
            .responseData { response in
                switch response.result {
                case let .success(data):
                    //MARK: Connection Success
                    do {
                        let object = try decoder.decode(APIResult<T>.self, from: data)
                        observer.onNext(object)
                        observer.onCompleted()
                        
                    } catch let error {
                        observer.onError(APIError.DECODING(error))
                    }
                case let .failure(error):
                    observer.onError(APIError.HTTP(error))
                }
            }
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func requestPlain<T>(
        _ requestBuilder: RequestBuilder,
        _ decoder: JSONDecoder = JSONDecoder()
    ) -> Observable<T> where T: Decodable {
        let authenticator = TokenAuthenticator()
        let credential = TokenCredential(
            accessToken: "set access token here",
            refreshToken: "set refresh token here"
        )
        
        let interceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credential
        )
                            
        return Observable.create { observer in
            let request = SessionManager.shared.getSession()?.request(
                requestBuilder.url,
                method: requestBuilder.method,
                parameters: requestBuilder.parameters,
                encoding: requestBuilder.parameterEncoding,
                headers: requestBuilder.headers,
                interceptor: interceptor
            )
            .validate(statusCode: Array(200..<300))
            .responseData { response in
                switch response.result {
                case let .success(data):
                    //MARK: Connection Success
                    do {
                        let object = try decoder.decode(T.self, from: data)
                        observer.onNext(object)
                        observer.onCompleted()
                        
                    } catch let error {
                        observer.onError(APIError.DECODING(error))
                    }
                case let .failure(error):
                    observer.onError(APIError.HTTP(error))
                }
            }
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
//    func upload<T>(
//        _ requestBuilder: RequestBuilder,
//        _ decoder: JSONDecoder = JSONDecoder()
//    ) -> Observable<APIResult<T>> where T: Decodable {
//        let authenticator = TokenAuthenticator()
//        let credential = TokenCredential(
//            accessToken: "set access token here",
//            refreshToken: "set refresh token here"
//        )
//
//        let interceptor = AuthenticationInterceptor(
//            authenticator: authenticator,
//            credential: credential
//        )
//
//        var uploadRequest: DataRequest {
//            let request = SessionManager.shared.getSession()?.request(
//                requestBuilder.url,
//                method: requestBuilder.method,
//                parameters: requestBuilder.parameters,
//                encoding: JSONEncoding.default,
//                headers: requestBuilder.headers
//            )
//            return request!
//        }
//
//        return Observable.create { observer in
//            let request = SessionManager.shared.getSession()?.upload(
//                multipartFormData: { formData in
//                    //MARK: handle parameter
//                    if let body = requestBuilder.parameters {
//                        for (key, value) in body {
//                            if let data = value as? Dictionary<String, Any>,
//                               let jsonData = data.jsonData {
//                                formData.append(jsonData,
//                                                withName: key,
//                                                mimeType: "application/json")
//                            } else {
//                                formData.append("\(value)".data(using: .utf8)!,
//                                                withName: key,
//                                                mimeType: "text/plain")
//                            }
//                        }
//                    }
//
//                    //MARK: handle multipart type
//                    if let multiparts = requestBuilder.multipartData {
//                        for multipart in multiparts {
//                            for (key, value) in multipart.data {
//                                guard let data = value else { return }
//
//                                formData.append(data, withName: key,
//                                                fileName: multipart.fileName,
//                                                mimeType: multipart.mimiType)
//                            }
//                        }
//                    }
//                },
//                with: uploadRequest.convertible,
//                interceptor: interceptor
//            )
//            .validate(statusCode: Array(200..<300))
//            .responseData { response in
//                switch response.result {
//                case .success(let data):
//                    do {
//                        let object = try decoder.decode(APIResult<T>.self, from: data)
//                        observer.onNext(object)
//                        observer.onCompleted()
//                    } catch let e {
//                        observer.onError(APIError.DECODING(e))
//                    }
//
//                case .failure(let error):
//                    //MARK: Connection Failed
//                    observer.onError(APIError.HTTP(error))
//
//                }
//            }
//
//            return Disposables.create {
//                request?.cancel()
//            }
//        }
//    }
}

