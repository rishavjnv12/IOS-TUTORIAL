//
//  NetWorkManager.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 14/09/22.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    private func getUrlRequestFromAPI(_ api: API) -> URLRequest?{
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.baseUrl
        components.path = api.path
        
        var urlQueryItems:[URLQueryItem] = []
        if let queryParam = api.queryParam {
            queryParam.forEach{ element in
                let URLQueryItem = URLQueryItem(name: element.key, value: element.value)
                urlQueryItems.append(URLQueryItem)
            }
        }
        components.queryItems = urlQueryItems
        
        
        guard let url = components.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.headers
        urlRequest.httpBody = nil
        
        return urlRequest
    }
    
    func fetchResponse<T: Decodable>(api: API, completion: @escaping (T?) -> Void) {
        guard let urlRequest = getUrlRequestFromAPI(api) else {
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("error")
                return
            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            let object = try? decoder.decode(T.self, from:data)
            DispatchQueue.main.async(execute:{ () -> Void in
                completion(object)
            })
        }).resume()
    }
    
    func fetchImage(url: String, completion: @escaping (Data) -> Void) {
        guard let nsUrl = NSURL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: nsUrl as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error as Any)
                return
            }
            guard let data = data else {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                completion(data)
            })
        }).resume()
    }
}

protocol API {
    var scheme: String { get }
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParam: [String: String]? { get }
    var headers: [String: String]?  { get }
    var body: [String: String]? { get }
}

extension API {
    var baseUrl: String {
        return .APIConstants.baseUrl.rawValue
    }
    
    var scheme: String {
        return .APIConstants.scheme.rawValue
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var body: [String: String]? {
        return nil
    }
    
    var headers: [String: String]? {
        return [
            "authorization":"token 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"
        ]
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

