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
        var authorization = ""
        if let request = request.request,
           let accessToken = request.headers["Authorization"] {
            authorization = accessToken
        } else {
            authorization = "No Token"
        }
        
        print("""
        \n⚪️
        🙎‍♂️ Authorization: \(authorization)
        
        - URL: \(request.request?.url?.absoluteString ?? ""))
        - Method: \(String(describing: request.request?.httpMethod))
        - Header:\n\(request.request?.allHTTPHeaderFields ?? [:])
        - Parameter:\n\(String(describing: request.request?.httpBody?.toPrettyPrinted)))
        """)
    }
    
    func request(_ request: DataRequest,
                 didValidateRequest urlRequest: URLRequest?,
                 response: HTTPURLResponse, data: Data?,
                 withResult result: Request.ValidationResult) {
        switch result {
        case .success:
            print("""
            \n🟢
            - URL: \(String(describing: request.request?.url?.absoluteString))
            - Method: \(String(describing: request.request?.httpMethod))
            - StatusCode: \(response.statusCode)
            - Data:\n\(String(describing: data?.toPrettyPrinted)))
            
            """
            )
        case .failure(let error):
            print("""
            \n🔴
            - URL: \(String(describing: request.request?.url?.absoluteString))
            - StatusCode:\(response.statusCode)
            - Error: \(error.localizedDescription)
            - Data:\n\(String(describing: data?.toPrettyPrinted))
            
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
