//
//  MTTHomeCollectionViewCell.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/2/3.
//

import UIKit

class MTTHomeCollectionViewCell: UICollectionViewCell {
    
    var subjectTitleLabel: UILabel!
    var subjectIconImageView: UIImageView!
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .yellow
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        setupSubviews()
    }
    
    /// 初始化子控件
    private func setupSubviews() -> Void {
        subjectTitleLabel = UILabel()
        subjectTitleLabel.text = "数学"
        subjectTitleLabel.font = .systemFont(ofSize: 13)
        subjectTitleLabel.textColor = .black
        subjectTitleLabel.textAlignment = .center
        self.contentView.addSubview(subjectTitleLabel)
        
        subjectTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.height.equalTo(24)
        }
        
        subjectIconImageView = UIImageView()
        subjectIconImageView.isUserInteractionEnabled = true
        subjectIconImageView.backgroundColor = .red
        self.contentView.addSubview(subjectIconImageView)
        
        subjectIconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(20)
            make.width.height.equalTo(44)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
