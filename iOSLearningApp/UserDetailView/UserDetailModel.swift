//
//  UserDetailModel.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 14/09/22.
//

import Foundation

class UserDetail: NSObject, Decodable, Encodable{
    var login: String?
    var avatar_url: String?
    var name: String?
    var email: String?
    var type: String?
    var company: String?
    var public_repos: Int?
    var followers: Int?
    var followings: Int?
}

