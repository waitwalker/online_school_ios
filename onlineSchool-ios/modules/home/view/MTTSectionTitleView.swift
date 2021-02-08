//
//  MTTSectionTitleView.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/2/8.
//

import UIKit

class MTTSectionTitleView: UIView {
    
    
    private var sectionTitleLabel: UILabel!
    var sectionTitle: String? {
        didSet {
            sectionTitleLabel.text = sectionTitle
        }
    }
    
    
    
    convenience init(_ frame: CGRect, sectionTitle: String) {
        self.init(frame: frame)
        self.sectionTitle = sectionTitle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let sectionContainer: UIView = UIView()
        self.addSubview(sectionContainer)
        sectionContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 20)
        
        let sectionIconView: UIView = UIView()
        sectionContainer.addSubview(sectionIconView)
        sectionIconView.backgroundColor = UIColor(hex: "#FF9918")
        sectionIconView.layer.cornerRadius = 2.5
        sectionContainer.clipsToBounds = true
        sectionIconView.layer.shadowOpacity = 0.7
        sectionIconView.layer.shadowRadius = 2
        sectionIconView.layer.shadowColor = UIColor(hex: "#FF9918").cgColor
        sectionIconView.layer.shadowOffset = CGSize(width: 0, height: 2)
        sectionIconView.frame = CGRect(x: 20, y: 3, width: 5, height: 14)
        
        
        sectionTitleLabel = UILabel()
        sectionTitleLabel.text = sectionTitle
        sectionTitleLabel.frame = CGRect(x: 30, y: 0, width: self.bounds.size.width - 30, height: 20)
        sectionTitleLabel.textAlignment = .left
        sectionTitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        sectionContainer.addSubview(sectionTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
