//
//  UserViewModel.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 13/09/22.
//

import Foundation

class PullRequestViewModel {
    internal var sampleResponse = Response()
    private var pageNumber:Int = 1
    private var pageSize:Int = 10
    weak var delegate: PullRequestViewControllerProtocol?
    
    func fetchData() {
        if pageNumber == 1{
            sampleResponse.items = []
        }
        
        let apiUrl = "https://api.github.com/repos/apple/swift/pulls?page=\(pageNumber)&per_page=\(pageSize)"
        NetworkManager.shared.fetchResponse(apiUrl: apiUrl) {(data : [Item]?) in
            if let data = data{
                self.sampleResponse.items?.append(contentsOf: data)
                if(self.pageNumber == 1){
                    self.delegate?.initialDataLoaded()
                }else{
                    self.delegate?.nextPageLoaded()
                }
                self.pageNumber += 1
            }else{
                self.delegate?.failedToload()
            }
        }
    }
        
    
    func viewLoaded() {
        self.delegate?.showLoader()
        self.fetchData()
    }
}
