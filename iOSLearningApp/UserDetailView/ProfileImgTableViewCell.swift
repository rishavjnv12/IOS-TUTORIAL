//
//  ProfileImgViewCell.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 19/09/22.
//

import Foundation
import UIKit

class ProfileImgTableViewCell: UITableViewCell {
    private let profileImageView = UIImageView()
    private let container = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.selectionStyle = .none
        contentView.addSubview(container)
        container.snp.makeConstraints{make in
            make.left.top.right.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        container.addSubview(profileImageView)
        profileImageView.image = UIImage(named: "user")

        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1.5
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 5
        profileImageView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(150)
        }
    }
    
    func setImage(_ image: UIImage){
        profileImageView.image = image
    }
}
