//
//  NetworkLogger.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/10.
//

import Foundation
import Alamofire

class NetworkLogger: EventMonitor {
    var queue: DispatchQueue {
        return Queues.loggerQueue
    }
    
    func request(_ request: Request, didCreateTask task: URLSessionTask) {
        var authorization = String.empty
        if let request = request.request,
           let accessToken = request.headers[Constants.APIMeta.AUTHORIZATION] {
            authorization = accessToken
        } else {
            authorization = "No Token"
        }
        
        log.info("""
        \n⚪️
        🙎‍♂️ Authorization: \(authorization)
        
        - URL: \(request.request?.url?.absoluteString ?? ""))
        - Method: \(String(describing: request.request?.httpMethod))
        - Header:\n\(request.request?.allHTTPHeaderFields ?? [:])
        - Parameter:\n\(JSON(request.request?.httpBody as Any))
        """)
    }
    
    func request(_ request: DataRequest,
                 didValidateRequest urlRequest: URLRequest?,
                 response: HTTPURLResponse, data: Data?,
                 withResult result: Request.ValidationResult) {
        switch result {
        case .success:
            log.info("""
            \n🟢
            - URL: \(String(describing: request.request?.url?.absoluteString))
            - Method: \(String(describing: request.request?.httpMethod))
            - StatusCode: \(response.statusCode)
            - Data:\n\(JSON(data as Any))
            
            """
            )
        case .failure(let error):
            log.info("""
            \n🔴
            - URL: \(String(describing: request.request?.url?.absoluteString))
            - StatusCode:\(response.statusCode)
            - Error: \(error.localizedDescription)
            - Data:\n\(JSON(data as Any))
            
            """
            )
        }
    }
}

extension Data {
    var toPrettyPrinted: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                  return nil
              }
        
       return prettyPrintedString as String
    }
}
