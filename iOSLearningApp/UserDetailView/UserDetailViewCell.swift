//
//  UserDetailViewCell.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 18/09/22.
//

import Foundation
import UIKit

class UserDetailTableViewCell: UITableViewCell {
    // MARK: private properties
    private let containerView = UIView()
    private let keyLabel = UILabel()
    private let valueLabel = UILabel()
    
    // MARK: private methods
    private func configureView() {
        self.selectionStyle = .none
        self.contentView.addSubview(containerView)
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)
        valueLabel.textColor = .gray
        
        keyLabel.snp.makeConstraints{make in
            make.left.top.equalToSuperview().offset(SizeContsants.boundaryMargin)
            make.bottom.equalToSuperview().offset(-SizeContsants.boundaryMargin)
        }
        
        valueLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(SizeContsants.boundaryMargin)
            make.right.bottom.equalToSuperview().offset(-SizeContsants.boundaryMargin)
        }
    }
    
    // MARK: public methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }
}
