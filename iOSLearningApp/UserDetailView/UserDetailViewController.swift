//
//  UserDetailViewController.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 14/09/22.
//

import Foundation
import UIKit
import SnapKit

class UserDetailViewController: UIViewController{
    // MARK: private properties
    private let viewModel = UserDetailViewModel()
    private let tableView = UITableView()
    private var dataFetched = false
    
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    private let loadingView = LoaderView()
    private let userDetailFields = UserDetailFieldsConstants.UserDetailFields
    
    // MARK: public methods
    init(userName: String){
        super.init(nibName: nil, bundle: nil)
        self.viewModel.userName = userName
        self.title = userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewModel.delegate = self
        configureButtons()
        showTableView()
        viewModel.fetchData()
    }
}

extension UserDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFetched ? userDetailFields.count + 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImgTableViewCell.description()) as? ProfileImgTableViewCell else {
                return UITableViewCell()
            }
            viewModel.setImage(cell)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailTableViewCell.description()) as? UserDetailTableViewCell else {
                return UITableViewCell()
            }
            let key = userDetailFields[indexPath.row - 1]
            let value = viewModel.getKeyValueFor(key)
            cell.setData(key: key, value: value)
            return cell
        }
    }
}

extension UserDetailViewController: UserDetailViewControllerProtocol {
    @objc private func saveUserData() {
        viewModel.saveUserData()
    }

    @objc private func deleteUserData() {
        viewModel.deleteButtonTapped()
    }
    
    @objc private func addToFavourite() {
        viewModel.addToFavourite()
    }

    @objc private func removeFromFavourite() {
        viewModel.removeFromFavourite()
    }

    // MARK: public methods
    func showLoader() {
        view.backgroundColor = .Theme.primary
        view.addSubview(loadingView)

        loadingView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func showTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .Theme.primary
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.register(UserDetailTableViewCell.self, forCellReuseIdentifier: UserDetailTableViewCell.description())
        tableView.register(ProfileImgTableViewCell.self, forCellReuseIdentifier: ProfileImgTableViewCell.description())
        view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func hideLoader() {
        spinner.stopAnimating()
        loadingView.isHidden = true
        loadingView.removeFromSuperview()
    }
    
    func configureButtons() {
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: .Icon.download,
                                             style: .plain,
                                             target: self,
                                             action: #selector(saveUserData)),
            UIBarButtonItem(image: .Icon.star,
                                             style: .plain,
                                             target: self,
                                             action: #selector(addToFavourite))
        ]
    }
    
    func dataLoaded() {
        hideLoader()
        dataFetched = true
        tableView.reloadData()
    }
    
    func errorOccurred() {
        print(String.Error.errorMsg.rawValue)
    }
    
    func showDeleteButton() {
        self.navigationItem.rightBarButtonItems?[0] = UIBarButtonItem(image: .Icon.delete,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(deleteUserData))
    }

    func showDownloadButton(){
        self.navigationItem.rightBarButtonItems?[0] = UIBarButtonItem(image: .Icon.download,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(saveUserData))
    }
    
    func showFavouriteButtton() {
        self.navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(image: .Icon.star,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addToFavourite))
    }
    
    func showUnfavouriteButton() {
        self.navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(image: .Icon.filledStar,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(removeFromFavourite))
    }
    
    func askDeleteConfirmation() {
        let dialogMessage = UIAlertController(title: .Alert.delete.rawValue, message: .Alert.askDeletionConfirmation.rawValue , preferredStyle: .alert)

        let deleteData: (UIAlertAction)->Void = {make in
            self.viewModel.deleteUserData()
        }
        let yes = UIAlertAction(title: .Alert.yes.rawValue, style: .destructive, handler: deleteData)
        let no = UIAlertAction(title: .Alert.no.rawValue, style: .cancel, handler: nil)

        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    func showDataSavedAlert() {
        let dialogMessage = UIAlertController(title: .Alert.saved.rawValue, message: .Alert.savedConfirmation.rawValue, preferredStyle: .alert)
        let ok = UIAlertAction(title: .Alert.ok.rawValue, style: .default, handler: nil)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    func showDeleteConfirmationalert() {
        let dialogMessage = UIAlertController(title: .Alert.deleted.rawValue, message: .Alert.deletionConfirmation.rawValue, preferredStyle: .alert)
        let ok = UIAlertAction(title: .Alert.ok.rawValue, style: .default, handler: nil)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

protocol UserDetailViewControllerProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func dataLoaded()
    func errorOccurred()
    func showDataSavedAlert()
    func showDownloadButton()
    func showDeleteButton()
    func askDeleteConfirmation()
    func showDeleteConfirmationalert()
    func showFavouriteButtton()
    func showUnfavouriteButton()
}
