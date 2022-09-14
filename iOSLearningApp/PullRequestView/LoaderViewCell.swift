//
//  LoaderViewCell.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 13/09/22.
//

import Foundation
import UIKit

class LoaderViewCell: UITableViewCell{
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.contentView.backgroundColor = .lightGray
        self.contentView.addSubview(spinner)
        spinner.color = .white
        spinner.snp.makeConstraints{make in
            make.top.bottom.left.right.equalToSuperview().offset(10)
        }
    }
}
