//
//  UserViewModel.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 13/09/22.
//

import Foundation

class PullRequestViewModel {
    var sampleResponse: Response!
    
    func fetchData(apiUrl: String,initialResponse: Response?,success:@escaping (Response)->(), failure:@escaping ()->()) {
        if initialResponse == nil{
            sampleResponse = Response()
            sampleResponse.items = []
        } else {
            sampleResponse = initialResponse
        }
        
        URLSession.shared.dataTask(with: NSURL(string: apiUrl)! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error ?? "error")
                    failure()
                    return
                }
                let decoder = JSONDecoder()
                let object = try? decoder.decode([Item].self, from:data!)
                DispatchQueue.main.async(execute:{ () -> Void in
                    self.sampleResponse.items?.append(contentsOf: object!)
                    success(self.sampleResponse)
                })
            }).resume()
     }
}
