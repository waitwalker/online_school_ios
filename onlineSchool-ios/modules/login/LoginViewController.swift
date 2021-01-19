//
//  LoginViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/19.
//

import UIKit

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 顶部图片
        let topImageView = UIImageView(image: UIImage(named: "login_background_top"))
        self.view.addSubview(topImageView)
        topImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(160)
        }
        
        /// 用户登录
        let userLoginLabel = UILabel()
        userLoginLabel.text = "用户登录"
        userLoginLabel.textColor = .black
        userLoginLabel.textAlignment = .left
        userLoginLabel.font = .systemFont(ofSize: 22, weight: .bold)
        self.view.addSubview(userLoginLabel)
        userLoginLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.top.equalTo(160)
        }
        
    }
    

}
