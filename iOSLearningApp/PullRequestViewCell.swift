//
//  CustomTableViewCell.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 13/09/22.
//

import Foundation
import UIKit

class PullRequestViewCell: UITableViewCell{
    let container = UIView()

    var profileImage = UIImageView()
    let userInfoView = UIView()
    
    let titleLabel = UILabel(frame: .zero)
    let subTitleLabel = UILabel(frame: .zero)
    let userDesc = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    func configure() {
        self.backgroundColor = .black
        setUpContainer()
        setUpProfileImage()
        setUpInfoView()
        setUpTitlLabel()
        setUpSubtitleLabel()
        setUpUserDesc()
    }
    
    func setUpContainer(){
        self.contentView.addSubview(container)
        
        container.backgroundColor = .white
        container.clipsToBounds = true
        container.layer.cornerRadius = 10
        container.snp.makeConstraints{make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
    }
    
    func setUpProfileImage() {
        self.container.addSubview(profileImage)
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        profileImage.snp.makeConstraints{make in
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(100.0)
            make.centerY.equalToSuperview()
        }
    }
    
    func setUpInfoView() {
        self.container.addSubview(userInfoView)
        userInfoView.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(profileImage.snp.right)
        }
    }
    
    func setUpTitlLabel() {
        self.userInfoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
    }
    
    func setUpSubtitleLabel() {
        self.userInfoView.addSubview(subTitleLabel)
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 10)
        self.subTitleLabel.textColor = .gray

        subTitleLabel.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func setUpUserDesc() {
        self.userInfoView.addSubview(userDesc)
        userDesc.numberOfLines = 0
        userDesc.font = UIFont.systemFont(ofSize: 10)
        userDesc.snp.makeConstraints{make in
            make.top.equalTo(subTitleLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.greaterThanOrEqualTo(profileImage.snp.height)
        }
    }
    

    func setData(item: Item?){
        profileImage.image = UIImage(named: "user")
        URLSession.shared.dataTask(with: NSURL(string: (item?.user?.avatar_url) ?? "https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png")! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error ?? "error")
                    return
                }
                let image = UIImage(data: data!)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.profileImage.image = image
                })
            }).resume()

        self.titleLabel.text = item?.user?.login
        self.subTitleLabel.text = item?.title
        self.userDesc.text = item?.body
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
