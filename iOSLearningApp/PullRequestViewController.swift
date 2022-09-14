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
    
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let loadingView = UIView()
    
    var pageNumber:Int = 1
    var pageSize:Int = 10
    
    var response: Response!
    
    var userViewModel = PullRequestViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoader() {
        view.addSubview(loadingView)
        
        loadingView.backgroundColor = .white
        loadingView.snp.makeConstraints{make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        loadingLabel.text = "Loading..."
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
    
    func stopLoader() {
        spinner.stopAnimating()
        loadingView.isHidden = true
        loadingView.removeFromSuperview()
    }
    
    func showTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        
        tableView.register(PullRequestViewCell.self, forCellReuseIdentifier: "CustomeTableViewCell")
        tableView.register(LoaderViewCell.self, forCellReuseIdentifier: "LoaderViewCell")
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure() {
        titleLabel.text = "Users"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(50)
        }
        showLoader()
        
        let success: (_ res:Response) -> ()  = {(res)-> Void in
            self.stopLoader()
            self.response = res
            self.showTableView()
        }
        
        let showError: () -> ()  = {()-> Void in
            print("Inside error handler")
        }
        
        userViewModel.fetchData(apiUrl: "https://api.github.com/repos/apple/swift/pulls?page=\(pageNumber)&per_page=\(pageSize)",initialResponse: nil, success: success, failure: showError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}


extension PullRequestViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.response.items?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < self.response.items?.count ?? 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeTableViewCell") as! PullRequestViewCell
            let item = self.response.items?[indexPath.row]
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
        if(indexPath.row == (self.response.items?.count)! - 2){
            pageNumber += 1
            let success: (_ res:Response) -> ()  = {(res)-> Void in
                self.response = res
                self.tableView.reloadData()
            }
            
            let showError: () -> ()  = {()-> Void in
                print("Inside error handler")
            }
            userViewModel.fetchData(apiUrl: "https://api.github.com/repos/apple/swift/pulls?page=\(pageNumber)&per_page=\(pageSize)", initialResponse: self.response, success: success, failure: showError)
        }
    }
}

protocol PullRequestViewControllerProtocol {
    func initialDataLoaded()
}

