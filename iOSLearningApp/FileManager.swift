//
//  FileManager.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 10/09/22.
//

import Foundation

class FileManager {
    class func loadJson(fileName: String) -> Response? {
        let decoder = JSONDecoder()
        guard
             let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
             let data = try? Data(contentsOf: url),
             let object = try? decoder.decode(Response.self, from: data)
        else {
             return nil
        }

        return object
     }
}
