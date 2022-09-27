//
//  PullRequestAPI.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 15/09/22.
//

import Foundation
import NVNetworking

struct PullRequestAPI: API {
    let pageNumber: Int
    let pageSize: Int = 10
    
    var path: String {
        return .API.pullRequest.rawValue
    }
    
    var queryParam: [String : String]? {
        return ["page": "\(pageNumber)", "per_page": "\(pageSize)"]
    }
}
