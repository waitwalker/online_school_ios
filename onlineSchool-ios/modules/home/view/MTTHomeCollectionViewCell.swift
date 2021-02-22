//
//  MTTHomeCollectionViewCell.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/2/3.
//

import UIKit
import NetworkLibrary
import URLNavigator

class MTTHomeCollectionViewCell: UICollectionViewCell {
    
    var subjectTitleLabel: UILabel!
    var subjectIconImageView: UIImageView!
    
    var gradeScrollView: UIScrollView!
    
    var model: HomeCourseDataModel? {
        didSet {
            if let dataModel = model {
                subjectTitleLabel.text = dataModel.subjectName
                let (image, color) = itemParameter(dataModel)
                self.contentView.backgroundColor = color
                subjectIconImageView.image = UIImage(named: image)
                addGradeViews(dataModel)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        setupSubviews()
    }
    
    func setupTap() -> Void {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.contentView.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() -> Void {
        
    }
    
    public func setDataSource(_ data: HomeCourseDataModel) -> Void {
        
    }
    
    /// 初始化子控件
    private func setupSubviews() -> Void {
        subjectTitleLabel = UILabel()
        subjectTitleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        subjectTitleLabel.textColor = .white
        subjectTitleLabel.textAlignment = .center
        self.contentView.addSubview(subjectTitleLabel)
        
        subjectTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.height.equalTo(24)
        }
        
        subjectIconImageView = UIImageView()
        subjectIconImageView.isUserInteractionEnabled = true
        self.contentView.addSubview(subjectIconImageView)
        
        subjectIconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(25)
            make.width.height.equalTo(44)
        }
        
        gradeScrollView = UIScrollView()
        gradeScrollView.isScrollEnabled = true
        gradeScrollView.bounces = true
        gradeScrollView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(gradeScrollView)
        
        gradeScrollView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-6)
            make.right.equalTo(0)
            make.height.equalTo(24)
        }
    }
    
    func addGradeViews(_ m: HomeCourseDataModel) -> Void {
        for (index, value) in m.grades.enumerated() {
            print("\(value) \(index)")
            let gradeModel = value
            
            let gradeLabel: UILabel = UILabel()
            gradeLabel.textAlignment = .center
            gradeLabel.text = gradeName(gradeModel.gradeId)
            gradeLabel.textColor = .white
            gradeLabel.font = .systemFont(ofSize: 10, weight: .bold)
            gradeLabel.layer.cornerRadius = 7
            gradeLabel.clipsToBounds = true
            gradeLabel.backgroundColor = UIColor(hex: "#000000", alpha: 0.20)
            gradeScrollView.addSubview(gradeLabel)
            
            gradeLabel.frame = CGRect(x: 30 * index + 5 * index, y: 2, width: 30, height: 20)
            
        }
        
        gradeScrollView.contentSize = CGSize(width: m.grades.count * (5 + 30), height: 24)
        
    }
    
    private func itemParameter(_ m: HomeCourseDataModel) -> (String, UIColor) {
        if m.subjectId == 1 {
            return ("image_courses_language", UIColor(hex: "#65D2FE"))
        } else if m.subjectId == 2 {
            return ("image_courses_math", UIColor(hex: "#FFCE65"))
        } else if m.subjectId == 3 {
            return ("image_courses_english", UIColor(hex: "#FDAD58"))
        } else if m.subjectId == 4 {
            return ("image_courses_physics", UIColor(hex: "#AA91FF"))
        } else if m.subjectId == 5 {
            return ("image_courses_chemistry", UIColor(hex: "#9191FF"))
        } else if m.subjectId == 6 {
            return ("image_courses_history", UIColor(hex: "#8AACFF"))
        } else if m.subjectId == 7 {
            return ("image_courses_biology", UIColor(hex: "#9ADE4D"))
        } else if m.subjectId == 8 {
            return ("image_courses_geography", UIColor(hex: "#5B9EFF"))
        } else if m.subjectId == 9 {
            return ("image_courses_politics", UIColor(hex: "#9191FF"))
        } else {
            return ("image_courses_science", UIColor(hex: "#80E06C"))
        }
    }
    
    private func gradeName(_ gradeId: Int) -> String {
        if        gradeId == 1 {
            return "高三"
        } else if gradeId == 2 {
            return "高二"
        } else if gradeId == 3 {
            return "高一"
        } else if gradeId == 4 {
            return "初三"
        } else if gradeId == 5 {
            return "初二"
        } else if gradeId == 6 {
            return "初一"
        } else if gradeId == 7 {
            return "小六"
        } else if gradeId == 8 {
            return "小五"
        } else if gradeId == 9 {
            return "小四"
        } else if gradeId == 10 {
            return "小三"
        } else if gradeId == 11 {
            return "小二"
        } else if gradeId == 12 {
            return "小一"
        } else {
            return ""
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
