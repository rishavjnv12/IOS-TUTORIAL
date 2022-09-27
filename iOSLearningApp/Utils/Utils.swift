//
//  Utils.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 21/09/22.
//

import Foundation

class Utils {
    private init() { }
    
    // MARK: public properties
    static let shared = Utils()
    func getKeyForfavourite(_ userName: String)-> String {
       return "favourite:\(userName)"
    }

}

