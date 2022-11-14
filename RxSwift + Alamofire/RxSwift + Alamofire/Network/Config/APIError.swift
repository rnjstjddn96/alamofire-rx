//
//  APIError.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/14.
//

import Foundation
import Alamofire

enum APIError: Error {
    case HTTP(AFError)
    case DECODING(Error)
    case UNKNOWN
    
    var title: String {
        switch self {
        case .DECODING:
            return "Decoding Failed"
        case .HTTP(let error):
            let responseCode = (error.responseCode == nil) ? "" : "_\(error.responseCode!)"
            return "Failed to get data: \(responseCode)"
        case .UNKNOWN:
            return "Unknown error occured"
        }
    }
    
    var reason: String {
        switch self {
        case .HTTP(let error):
            if error.isSessionTaskError {
                return "Session task error occured."
            } else {
                return error.errorDescription ?? ""
            }
        case .DECODING(let error):
            guard let error = error as? DecodingError else {
                return error.localizedDescription
            }
            
            switch error {
            case .keyNotFound(let key, let context):
                return "\(key.stringValue) does not matches to data\n\(context.debugDescription)"
            case .dataCorrupted(let context):
                return context.debugDescription
            case .typeMismatch(_, let context):
                return context.debugDescription
            case .valueNotFound(_, let context):
                return context.debugDescription
            @unknown default:
                return error.localizedDescription
            }
            
        case .UNKNOWN:
            return "Unknown error occured"
        }
    }
}
