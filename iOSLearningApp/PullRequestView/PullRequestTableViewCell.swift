//
//  CustomTableViewCell.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 13/09/22.
//

import Foundation
import UIKit
import NVNetworking

final class PullRequestTableViewCell: UITableViewCell {
    // MARK: private properties
    private let containerView = UIView()

    private let profileImageView = UIImageView()
    private let userInfoView = UIView()
    
    private let titleLabel = UILabel(frame: .zero)
    private let subTitleLabel = UILabel(frame: .zero)
    private let userDesc = UILabel()
    
    private let favouriteView = UIView()
    private let button = UIButton()
    
    // MARK: button callback
    var buttonTappedCallback :()->() = {}
    @objc func buttonTapped() {
        buttonTappedCallback()
    }
    
    // MARK: public methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    func setData(item: Item?){
        profileImageView.image = UIImage(named: "user")
        let setImage = {(data: Data) -> Void in
            guard let image = UIImage(data: data) else {
                return
            }
            self.profileImageView.image = image
        }
        guard let avatar_url = item?.user?.avatar_url else {
            return
        }
        NetworkManager.shared.fetchImage(url: avatar_url, completion: setImage)

        self.titleLabel.text = item?.user?.login
        self.subTitleLabel.text = item?.title
        self.userDesc.text = item?.body
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setFavouriteState() {
        button.setImage(.Icon.filledStar, for: UIControl.State.normal)
    }
    
    func setUnFavouriteState() {
        button.setImage(.Icon.star, for: UIControl.State.normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: private methods
private extension PullRequestTableViewCell {
    func configureView() {
        self.selectionStyle = .none
        self.backgroundColor = .Theme.primary
        setUpContainerView()
        setUpProfileImage()
        setUpInfoView()
        setUpTitlLabel()
        setUpSubtitleLabel()
        setUpFavouriteView()
        setUpUserDesc()
    }
    
    func setUpContainerView(){
        self.contentView.addSubview(containerView)
        
        containerView.backgroundColor = .Theme.primary
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 0.2

        containerView.snp.makeConstraints{make in
            make.top.left.equalToSuperview().offset(SizeContsants.boundaryMargin)
            make.bottom.right.equalToSuperview().offset(-SizeContsants.boundaryMargin)
        }
    }
    
    func setUpProfileImage() {
        self.containerView.addSubview(profileImageView)
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = CGFloat(SizeContsants.pullRequestImgDimension / 2)
        profileImageView.snp.makeConstraints{make in
            make.left.equalToSuperview().offset(SizeContsants.boundaryMargin)
            make.height.width.equalTo(SizeContsants.pullRequestImgDimension)
            make.centerY.equalToSuperview()
        }
    }
    
    func setUpInfoView() {
        self.containerView.addSubview(userInfoView)
        userInfoView.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(profileImageView.snp.right)
        }
    }
    
    func setUpTitlLabel() {
        self.userInfoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SizeContsants.boundaryMargin)
            make.right.equalToSuperview().offset(-SizeContsants.boundaryMargin)
            make.top.equalToSuperview().offset(SizeContsants.boundaryMargin)
        }
    }
    
    func setUpSubtitleLabel() {
        self.userInfoView.addSubview(subTitleLabel)
        self.subTitleLabel.font = UIFont.systemFont(ofSize: CGFloat(SizeContsants.boundaryMargin))
        self.subTitleLabel.textColor = .gray

        subTitleLabel.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(SizeContsants.boundaryMargin)
            make.right.equalToSuperview().offset(-SizeContsants.boundaryMargin)
        }
    }
    
    func setUpFavouriteView() {
        containerView.addSubview(favouriteView)
        
        favouriteView.snp.makeConstraints{make in
            make.left.equalTo(userInfoView.snp.right)
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        favouriteView.addSubview(button)
        button.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func setUpUserDesc() {
        self.userInfoView.addSubview(userDesc)
        userDesc.numberOfLines = 0
        userDesc.font = UIFont.systemFont(ofSize: CGFloat(SizeContsants.boundaryMargin))
        userDesc.snp.makeConstraints{make in
            make.top.equalTo(subTitleLabel.snp.bottom)
            make.left.equalToSuperview().offset(SizeContsants.boundaryMargin)
            make.right.equalToSuperview().offset(-SizeContsants.boundaryMargin)
            make.bottom.equalToSuperview().offset(-SizeContsants.boundaryMargin)
            make.height.greaterThanOrEqualTo(profileImageView.snp.height)
        }
    }
}
