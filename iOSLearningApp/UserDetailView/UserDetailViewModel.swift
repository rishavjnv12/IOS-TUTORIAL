//
//  UserDetailViewModel.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 14/09/22.
//

import Foundation
import UIKit
import NVNetworking
import NVDBManager

class UserDetailViewModel {
    // MARK: private property
    private let notificationCenter = NotificationCenter.default
    
    // MARK: public properties
    var userName: String = ""
    var userDetailResponse: UserDetail?
    weak var delegate: UserDetailViewControllerProtocol?
    
    // MARK: public methods
    func setImage(_ cell: ProfileImgTableViewCell) {
        guard let imgUrl = userDetailResponse?.avatar_url else {
            return
        }
        NetworkManager.shared.fetchImage(url: imgUrl) {data in
            guard let image = UIImage(data: data) else {
                return
            }
            cell.setImage(image)
        }
    }
    
    func fetchData() {
        if DatabaseManger.shared.getValue(key: Utils.shared.getKeyForfavourite(userName)) != nil {
            self.delegate?.showUnfavouriteButton()
        } else {
            self.delegate?.showFavouriteButtton()
        }
        
        if let jsonData = DatabaseManger.shared.getValue(key: userName) {
            self.delegate?.showLoader()
            self.userDetailResponse = try? JSONDecoder().decode(UserDetail.self, from:Data(jsonData.utf8))
            self.delegate?.dataLoaded()
            self.delegate?.showDeleteButton()
        } else {
            delegate?.showLoader()
            NetworkManager.shared.fetchResponse(api: UserDetailAPI(userName: userName), completion: {(data : UserDetail?) in
                if let data = data{
                    self.userDetailResponse = data
                    self.delegate?.dataLoaded()
                    self.delegate?.hideLoader()
                    self.delegate?.showDownloadButton()
                }else{
                    self.delegate?.errorOccurred()
                }
            })
        }
    }
    
    func addToFavourite() {
        DatabaseManger.shared.setValue(key: Utils.shared.getKeyForfavourite(userName), value: userName)
        notificationCenter.post(name: NSNotification.Name("observer"), object: nil)
        delegate?.showUnfavouriteButton()
    }
    
    func removeFromFavourite() {
        DatabaseManger.shared.removeForKey(key: Utils.shared.getKeyForfavourite(userName))
        notificationCenter.post(name: NSNotification.Name("observer"), object: nil)
        delegate?.showFavouriteButtton()
    }
    
    func getKeyValueFor(_ key: String)-> String {
        if key == .InfoLabel.name.rawValue {
            guard let val = userDetailResponse?.name else {
                return .InfoLabel.none.rawValue
            }
            return val
        } else if key == .InfoLabel.email.rawValue {
            guard let val = userDetailResponse?.email else {
                return .InfoLabel.none.rawValue
            }
            return val
        } else if key == .InfoLabel.type.rawValue {
            guard let val = userDetailResponse?.type else {
                return .InfoLabel.none.rawValue
            }
            return val
        } else if key == .InfoLabel.company.rawValue {
            guard let val = userDetailResponse?.company else {
                return .InfoLabel.none.rawValue
            }
            return val
        } else if key == .InfoLabel.public_repo.rawValue {
            guard let val = userDetailResponse?.public_repos else {
                return "0"
            }
            return "\(val)"
        } else if key == .InfoLabel.followers_count.rawValue {
            guard let val = userDetailResponse?.followers else {
                return "0"
            }
            return "\(val)"
        } else if key == .InfoLabel.followings_count.rawValue {
            guard let val = userDetailResponse?.followings else {
                return "0"
            }
            return "\(val)"
        }
        return .InfoLabel.none.rawValue
    }
    
    func saveUserData() {
        do{
            let encodedData = try JSONEncoder().encode(userDetailResponse)
            guard let jsonString = String(data: encodedData, encoding: .utf8) else {
                return
            }
            DatabaseManger.shared.setValue(key: userName, value: jsonString)
            self.delegate?.showDataSavedAlert()
            self.delegate?.showDeleteButton()
        } catch {
            print("failed to encode")
        }
    }
    
    func deleteButtonTapped() {
        self.delegate?.askDeleteConfirmation()
    }
    
    func deleteUserData() {
        DatabaseManger.shared.removeForKey(key: userName)
        self.delegate?.showDeleteConfirmationalert()
        self.delegate?.showDownloadButton()
    }
}

