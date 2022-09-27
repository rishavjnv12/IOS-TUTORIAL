//
//  Constants.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 14/09/22.
//

import Foundation
import UIKit


extension String{
    enum Label: String{
        case users = "Users"
        case loading = "Loading..."
    }
    
    
    
    enum InfoLabel: String {
        case name = "Name"
        case email = "Email"
        case type = "Type"
        case company = "Company"
        case public_repo = "Public Repo Count"
        case followers_count = "Follower's Count"
        case followings_count = "Following's Count"
        case none = "None"
    }
    
    enum API: String {
        case baseUrl = "api.github.com"
        case userDetail = "/users/"
        case pullRequest = "/repos/apple/swift/pulls"
        case scheme = "https"
    }
    
    enum Alert: String {
        case yes = "Yes"
        case no = "No"
        case ok = "OK"
        case deleted = "Deleted"
        case saved = "Saved"
        case delete = "Delete"
        case askDeletionConfirmation = "Are you sure?"
        case deletionConfirmation = "User Data deleted successfully"
        case savedConfirmation = "User Data saved successfully"
    }
    
    enum Error: String {
        case errorMsg = "Inside error handler"
    }
}
