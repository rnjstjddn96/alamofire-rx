//
//  NetworkService.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/11.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkServiceInterface: AnyObject {
    func request<T>(_ requestBuilder: RequestBuilder, _ decoder: JSONDecoder)
    -> Observable<APIResult<T>> where T: Decodable
    func upload<T>(_ requestBuilder: RequestBuilder, _ decoder: JSONDecoder)
    -> Observable<APIResult<T>> where T: Decodable
    func download(_ url: URL) -> Observable<(data: Data?, progress: Progress)>
}

final class NetworkService: NetworkServiceInterface {
    let session: Session?
    
    init() {
        self.session = SessionManager.shared.getSession()
    }
    
    func request<T>(_ requestBuilder: RequestBuilder, _ decoder: JSONDecoder = JSONDecoder())
                        -> Observable<APIResult<T>> where T: Decodable {
        let authenticator = MPayAuthenticator()
        let credential = MPayAuthenticationCredential(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        
        let authenticationInterceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credential
        )
        
        let baseInterceptor = BaseInterceptor()
        let interceptor: RequestInterceptor
                = requestBuilder.authentication ? authenticationInterceptor : baseInterceptor
                            
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create {
                    observer.onError(APIError.UNKNOWN)
                }
            }
            
            let request = self.session?.request(
                requestBuilder.url,
                method: requestBuilder.method,
                parameters: requestBuilder.parameters,
                encoding: requestBuilder.parameterEncoding,
                headers: requestBuilder.headers,
                interceptor: interceptor
            )
            .validate(statusCode: Constants.APIMeta.ResponseCode.HTTP_SUCCESS
                      + [Constants.APIMeta.ResponseCode.HTTP_BAD_PARAMTER,
                         Constants.APIMeta.ResponseCode.HTTP_NO_PERMISSION])
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
    
    func upload<T>(_ requestBuilder: RequestBuilder, _ decoder: JSONDecoder = JSONDecoder())
                                                -> Observable<APIResult<T>> where T: Decodable {
        let authenticator = MPayAuthenticator()
        let credential = MPayAuthenticationCredential(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        
        let authenticationInterceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credential
        )
        
        let baseInterceptor = BaseInterceptor()
        let interceptor: RequestInterceptor
                = requestBuilder.authentication ? authenticationInterceptor : baseInterceptor
                                                    
        var uploadRequest: DataRequest {
            let request = self.session?.request(
                requestBuilder.url,
                method: requestBuilder.method,
                parameters: requestBuilder.parameters,
                encoding: JSONEncoding.default,
                headers: requestBuilder.headers
            )
            return request!
        }
        
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create {
                    observer.onError(APIError.UNKNOWN)
                }
            }
           
            let request = self.session?.upload(multipartFormData: { formData in
                //MARK: handle parameter
                if let body = requestBuilder.parameters {
                    for (key, value) in body {
                        if let data = value as? Dictionary<String, Any>,
                           let jsonData = data.jsonData {
                            formData.append(jsonData,
                                            withName: key,
                                            mimeType: Constants.APIMeta.MIME_TYPE_JSON)
                        } else {
                            formData.append("\(value)".data(using: .utf8)!,
                                            withName: key,
                                            mimeType: Constants.APIMeta.MIME_TYPE_TEXT)
                        }
                    }
                }
                
                //MARK: handle multipart type
                if let multiparts = requestBuilder.multipartData {
                    for multipart in multiparts {
                        for (key, value) in multipart.data {
                            guard let data = value else { return }
                            
                            formData.append(data, withName: key,
                                            fileName: multipart.fileName,
                                            mimeType: multipart.mimiType)
                        }
                    }
                }
                
            }, with: uploadRequest.convertible, interceptor: interceptor)
                .validate(statusCode: Constants.APIMeta.ResponseCode.HTTP_SUCCESS
                          + [Constants.APIMeta.ResponseCode.HTTP_BAD_PARAMTER,
                             Constants.APIMeta.ResponseCode.HTTP_NO_PERMISSION])
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        //MARK: Connection Success
                        do {
                            let object = try decoder.decode(APIResult<T>.self, from: data)
                            observer.onNext(object)
                            observer.onCompleted()
                        } catch let error {
                            //MARK: Decoding Failed
                            observer.onError(APIError.DECODING(error))
                        }
                    case let .failure(error):
                        //MARK: Connection Failed
                            observer.onError(APIError.HTTP(error))
                    }
            }
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    func download(_ url: URL) -> Observable<DownloadResult> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create {
                    observer.onError(APIError.UNKNOWN)
                }
            }
            
            let downloadRequest = self.session?.download(url)
                .validate(statusCode: Array(200..<300) + [400, 403])
                .downloadProgress { progress in
                    observer.onNext((data: nil, progress: progress))
                }
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext((data: data, progress: Progress()))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(APIError.HTTP(error))
                    }
                }
            
            return Disposables.create { downloadRequest?.cancel() }
        }
    }
}

