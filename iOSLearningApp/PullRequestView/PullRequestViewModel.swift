//
//  UserViewModel.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 13/09/22.
//

import Foundation
import NVNetworking
import NVDBManager

final class PullRequestViewModel {
    // MARK: private properties
    private var firstPage = true
    private var pageNumber:Int = 55
    private var pageSize:Int = 10
    private var userToIndicesMap:[String:[IndexPath]] = [:]
    
    // MARK: public properties
    var sampleResponse = Response()
    weak var delegate: PullRequestViewControllerProtocol?
    var endOfData = false
    
    // MARK: public methods
    func fetchData() {
        if firstPage {
            sampleResponse.items = []
        }
        
        NetworkManager.shared.fetchResponse(api: PullRequestAPI(pageNumber: pageNumber), completion: { [self](data : [Item]?) in
            if let data = data{
                if data.count < self.pageSize {
                    self.endOfData = true
                }
                self.sampleResponse.items?.append(contentsOf: data)
                if self.firstPage {
                    self.firstPage = false
                    self.delegate?.initialDataLoaded()
                }else{
                    self.delegate?.reloadTable()
                }
                self.pageNumber += 1
            }else{
                self.delegate?.failedToload()
            }
        })
    }
    
    func isFavourite(userName: String)-> Bool {
        return DatabaseManger.shared.getValue(key: Utils.shared.getKeyForfavourite(userName)) != nil
    }
    
    func mapUser(userName: String, indexPath: IndexPath) {
        if userToIndicesMap[userName] != nil {
            userToIndicesMap[userName]?.append(indexPath)
        } else {
            userToIndicesMap[userName] = [indexPath]
        }
    }
    
    func toggleFavouriteState(_ userName: String) {
        let key = Utils.shared.getKeyForfavourite(userName)
        if DatabaseManger.shared.getValue(key: key) != nil {
            DatabaseManger.shared.removeForKey(key: key)
        } else {
            DatabaseManger.shared.setValue(key:key, value: userName)
        }
        delegate?.reloadCells(indices: userToIndicesMap[userName] ?? [])
    }
    
    func reachedAt(_ indexPath:IndexPath){
        guard let tableSize = sampleResponse.items?.count else {
            return
        }
        
        if endOfData {
            self.delegate?.reloadTable()
        }
        if(indexPath.row == tableSize - 2){
            fetchData()
        }
    }
    
    func viewLoaded() {
        self.delegate?.showLoader()
        self.fetchData()
    }
}
