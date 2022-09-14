//
//  Response.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 09/09/22.
//

import Foundation

struct Response: Decodable{
    var items: [Item]?
}

struct Item: Decodable {
    var id:Int?
    var title: String?
    var user:User?
    var body:String?
}

struct User: Decodable {
    var type:String?
    var id:Int?
    var login:String?
    var avatar_url:String?
}
