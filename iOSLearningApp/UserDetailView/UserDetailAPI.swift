//
//  UserDetailAPI.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 15/09/22.
//

import Foundation
import NVNetworking

struct UserDetailAPI: API {
    var userName: String
    var path: String {
        return .API.userDetail.rawValue + "\(userName)"
    }
    
    var queryParam: [String : String]? {
        return nil
    }
}
