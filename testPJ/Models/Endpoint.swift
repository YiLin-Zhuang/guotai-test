//
//  Endpoint.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

enum Endpoint {
    case notificationList(_ firstTime:Bool)
    case usdSavings(_ firstTime:Bool)
    case usdFixed(_ firstTime:Bool)
    case usdDigital(_ firstTime:Bool)
    case khrSavings(_ firstTime:Bool)
    case khrFixed(_ firstTime:Bool)
    case khrDigital(_ firstTime:Bool)
    case favoriteList(_ firstTime:Bool)
    case adBanner
}

extension Endpoint: URLRequestConvertible {

    private static let encoder = JSONEncoder()
    
    private var hostString: String {
        "https://willywu0201.github.io/data"
    }
    
    private var baseHeaders: [String : String] {
        return [:]
    }
    
    private var method: String {
        return "GET"
    }
    
    private var pathString: String {
        switch self {
        case .notificationList(let firstTime):
            return  firstTime ? "/emptyNotificationList.json" : "/notificationList.json"
        case .usdSavings(let firstTime):
            return firstTime ? "/usdSavings1.json" : "/usdSavings2.json"
        case .usdFixed(let firstTime):
            return firstTime ? "/usdFixed1.json" : "/usdFixed2.json"
        case .usdDigital(let firstTime):
            return firstTime ? "/usdDigital1.json" : "/usdDigital2.json"
        case .khrSavings(let firstTime):
            return firstTime ? "/khrSavings1.json" : "/khrSavings2.json"
        case .khrFixed(let firstTime):
            return firstTime ? "/khrFixed1.json" : "/khrFixed2.json"
        case .khrDigital(let firstTime):
            return firstTime ? "/khrDigital1.json" : "/khrDigital2.json"
        case .favoriteList(let firstTime):
            return firstTime ? "/emptyFavoriteList.json" : "/favoriteList.json"
        case .adBanner:
            return "/banner.json"
        }
    }
    
    
    private var headers: [String : String] {
        return baseHeaders
    }
    
    private var httpBody: Data? {
        switch self {
        default :
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(hostString)\(pathString)")!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = httpBody
        request.allHTTPHeaderFields = headers
        
        return request
    }
}

protocol baseResponse: Codable {
    var msgCode: String { get set }
    var msgContent: String { get set }
}
