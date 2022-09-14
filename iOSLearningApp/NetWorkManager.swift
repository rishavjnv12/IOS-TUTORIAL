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
    
    func fetchResponse<T: Decodable>(apiUrl: String, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: NSURL(string: apiUrl)! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("error")
                    return
                }
                let decoder = JSONDecoder()
                let object = try? decoder.decode(T.self, from:data!)
                DispatchQueue.main.async(execute:{ () -> Void in
                    completion(object)
                })
            }).resume()
    }
}
