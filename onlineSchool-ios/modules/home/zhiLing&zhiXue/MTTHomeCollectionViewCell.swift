//
//  MTTHomeCollectionViewCell.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/2/3.
//

import UIKit

class MTTHomeCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let containerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        containerView.backgroundColor = .red
        self.addSubview(containerView)
        self.contentView.backgroundColor = .yellow
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
