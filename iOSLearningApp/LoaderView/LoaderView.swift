//
//  LoaderView.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 27/09/22.
//

import Foundation
import UIKit

final class LoaderView: UIView {
    // MARK: private properties
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    
    private func setUpView() {
        self.addSubview(spinner)
        self.addSubview(loadingLabel)
        
        self.backgroundColor = .Theme.primary
        loadingLabel.text = .Label.loading.rawValue

        spinner.snp.makeConstraints{make in
            make.top.left.bottom.equalToSuperview()
        }
        loadingLabel.snp.makeConstraints{make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(spinner.snp.right)
        }
        spinner.startAnimating()
    }
    
    // MARK: public properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

