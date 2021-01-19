//
//  LoginViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/19.
//

import UIKit

class LoginViewController: BaseViewController {
    
    var accountInput: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 顶部图片
        let topImageView: UIImageView = UIImageView(image: UIImage(named: "login_background_top"))
        self.view.addSubview(topImageView)
        topImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(160)
        }
        
        /// 用户登录
        let userLoginLabel: UILabel = UILabel()
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
        
        /// 账号容器
        let accountContainer: UIView = UIView()
        accountContainer.backgroundColor = .white
        accountContainer.layer.cornerRadius = 20
        accountContainer.layer.shadowOpacity = 0.7
        accountContainer.layer.shadowRadius = 10
        accountContainer.layer.shadowColor = UIColor.gray.cgColor
        accountContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.view.addSubview(accountContainer)
        
        accountContainer.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(userLoginLabel.snp_bottomMargin).offset(30)
            make.height.equalTo(44)
        }
        
        /// 账号图标
        let accountIcon: UIImageView = UIImageView(image: UIImage(named: "account_placeholder_icon"))
        accountContainer.addSubview(accountIcon)
        accountIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(5)
            make.centerY.equalTo(accountContainer)
        }
        
        /// 账号输入框
        accountInput = UITextField()
        accountInput.textColor = .black
        accountInput.placeholder = "手机号/账号"
        accountInput.backgroundColor = .white
        accountContainer.addSubview(accountInput)
        accountInput.snp.makeConstraints { (make) in
            make.left.equalTo(accountIcon.snp_rightMargin).offset(15)
            make.top.height.equalTo(accountContainer)
            make.right.equalTo(-40)
        }
        
        /// 账户清空按钮
        let accountDelete: UIImageView = UIImageView(image: UIImage(named: "account_placeholder_icon"))
        accountDelete.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(accountDeleteTapAction))
        accountDelete.addGestureRecognizer(tap)
        accountContainer.addSubview(accountDelete)
        accountDelete.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(accountInput.snp_rightMargin).offset(10)
            make.centerY.equalTo(accountContainer)
        }
        
        
        
    }
    
    /// 清空按钮点击回调
    @objc func accountDeleteTapAction() -> Void {
        print("点击了account delete")
    }
    

}
