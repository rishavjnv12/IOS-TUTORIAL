//
//  ViewController.swift
//  iOSLearningApp
//
//  Created by Nveen Bandlamudi on 09/06/22.
//

import UIKit
import SnapKit


class PullRequestViewController: UIViewController {
    let tableView = UITableView()
    let titleLabel = UILabel()
    
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    private let loadingView = UIView()
    
    var viewModel = PullRequestViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = false
        
        tableView.register(PullRequestTableViewCell.self, forCellReuseIdentifier: "PullRequestViewCell")
        tableView.register(LoaderViewCell.self, forCellReuseIdentifier: "LoaderViewCell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure() {        
        titleLabel.text = .Constants.users.rawValue
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(50)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.configure()
        viewModel.viewLoaded()
    }
}


extension PullRequestViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel.sampleResponse.items?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < self.viewModel.sampleResponse.items?.count ?? 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PullRequestViewCell") as! PullRequestTableViewCell
            let item = self.viewModel.sampleResponse.items?[indexPath.row]
            cell.setData(item: item)
            return cell
        } else {
            let loader = tableView.dequeueReusableCell(withIdentifier: "LoaderViewCell") as! LoaderViewCell
            loader.spinner.startAnimating()
            return loader
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == (self.viewModel.sampleResponse.items?.count)! - 2){
            viewModel.fetchData()
        }
    }
}

extension PullRequestViewController: PullRequestViewControllerProtocol {
    func initialDataLoaded() {
        self.hideLoader()
        self.showTableView()
    }
    
    func nextPageLoaded() {
        self.tableView.reloadData()
    }
    
    func failedToload() {
        print("Inside error handler")
    }
    
    func showLoader() {
        view.addSubview(loadingView)
        
        loadingView.backgroundColor = .lightGray
        loadingView.snp.makeConstraints{make in
            make.top.left.bottom.right.equalToSuperview()
        }
        loadingLabel.text = .Constants.loading.rawValue
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(spinner)
        spinner.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(150)
        }
        loadingLabel.snp.makeConstraints{make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(spinner.snp.right)
        }
        spinner.startAnimating()
    }
    
    func hideLoader() {
        spinner.stopAnimating()
        loadingView.isHidden = true
        loadingView.removeFromSuperview()
    }
}

protocol PullRequestViewControllerProtocol: AnyObject {
    func initialDataLoaded()
    func nextPageLoaded()
    func failedToload()
    func showLoader()
    func hideLoader()
}

