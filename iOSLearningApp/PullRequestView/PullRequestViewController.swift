//
//  ViewController.swift
//  iOSLearningApp
//
//  Created by Nveen Bandlamudi on 09/06/22.
//

import UIKit
import SnapKit


class PullRequestViewController: UIViewController {
    // MARK: private properties
    private let tableView = UITableView()
    private let loadingView = LoaderView()
    private let notificationCenter = NotificationCenter.default
    private var endOfData = false
    private let viewModel = PullRequestViewModel()
    
    // MARK: public methods
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .Theme.primary
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.register(PullRequestTableViewCell.self, forCellReuseIdentifier: PullRequestTableViewCell.description())
        tableView.register(LoaderViewCell.self, forCellReuseIdentifier: LoaderViewCell.description())
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.title = .Label.users.rawValue
        viewModel.viewLoaded()
    }
}

// MARK: PullRequestViewController extension
extension PullRequestViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableSize = self.viewModel.sampleResponse.items?.count else {
            return 1
        }
        return tableSize + (viewModel.endOfData ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableSize = self.viewModel.sampleResponse.items?.count else {
            return UITableViewCell()
        }
        
        if indexPath.row < tableSize,
            let cell = tableView.dequeueReusableCell(withIdentifier: PullRequestTableViewCell.description()) as? PullRequestTableViewCell {
            let item = self.viewModel.sampleResponse.items?[indexPath.row]
            guard let userName = self.viewModel.sampleResponse.items?[indexPath.row].user?.login else {
                return cell
            }
            cell.buttonTappedCallback = { [weak self] in
                self?.viewModel.toggleFavouriteState(userName)
            }
            cell.setData(item: item)
            
            viewModel.mapUser(userName: userName, indexPath: indexPath)
            if viewModel.isFavourite(userName: userName){
                cell.setFavouriteState()
            } else {
                cell.setUnFavouriteState()
            }
            return cell
        } else {
            guard let loader = tableView.dequeueReusableCell(withIdentifier: LoaderViewCell.description()) as? LoaderViewCell else {
                return UITableViewCell()
            }
            loader.spinner.startAnimating()
            return loader
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let username = self.viewModel.sampleResponse.items?[indexPath.row].user?.login else {
            return
        }
        
        let userDetailViewController = UserDetailViewController(userName: username)
        
        let reloadTable:(Notification)->Void = {make in
            tableView.reloadData()
        }
        notificationCenter.addObserver(forName: NSNotification.Name("observer"), object: nil, queue: nil, using: reloadTable)
        self.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !viewModel.endOfData {
            viewModel.reachedAt(indexPath)
        }
    }
}

extension PullRequestViewController: PullRequestViewControllerProtocol {
    // MARK: public methods
    func initialDataLoaded() {
        self.hideLoader()
        self.showTableView()
    }
    
    func failedToload() {
        print(String.Error.errorMsg.rawValue)
    }
    
    func showLoader() {
        view.backgroundColor = .Theme.primary
        view.addSubview(loadingView)
        
        loadingView.backgroundColor = .Theme.primary
        loadingView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func hideLoader() {
        loadingView.isHidden = true
        loadingView.removeFromSuperview()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func reloadCells(indices: [IndexPath]) {
        tableView.reloadRows(at: indices, with: .none)
    }
}

protocol PullRequestViewControllerProtocol: AnyObject {
    func initialDataLoaded()
    func failedToload()
    func showLoader()
    func hideLoader()
    func reloadTable()
    func reloadCells(indices:[IndexPath])
}
