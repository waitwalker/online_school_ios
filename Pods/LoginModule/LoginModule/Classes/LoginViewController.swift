//
//  LoginViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/19.
//

import UIKit
import SnapKit
import ExtensionLibrary

@available(iOS 13.0, *)
public class LoginViewController: UIViewController {
    
    var accountInput: UITextField!
    var passwordInput: UITextField!
    var passwordSecurity: UIImageView!
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        /// 顶部图片
        let topImageView: UIImageView = UIImageView(image: UIImage.bundledImage("login_background_top"))
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
        let accountIcon: UIImageView = UIImageView(image: UIImage.bundledImage("account_placeholder_icon"))
        accountContainer.addSubview(accountIcon)
        accountIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(5)
            make.centerY.equalTo(accountContainer)
        }
        
        /// 账号输入框
        accountInput = UITextField()
        accountInput.text = "ett"
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
        let accountDelete: UIImageView = UIImageView(image: UIImage.bundledImage("login_account_clear_icon"))
        accountDelete.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(accountDeleteTapAction))
        accountDelete.addGestureRecognizer(tap)
        accountContainer.addSubview(accountDelete)
        accountDelete.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(accountInput.snp_rightMargin).offset(10)
            make.centerY.equalTo(accountContainer)
        }
        
        /// 密码容器
        let passwordContainer: UIView = UIView()
        passwordContainer.backgroundColor = .white
        passwordContainer.layer.cornerRadius = 20
        passwordContainer.layer.shadowOpacity = 0.7
        passwordContainer.layer.shadowRadius = 10
        passwordContainer.layer.shadowColor = UIColor.gray.cgColor
        passwordContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.view.addSubview(passwordContainer)
        
        passwordContainer.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(accountContainer.snp_bottomMargin).offset(40)
            make.height.equalTo(44)
        }
        
        /// 密码图标
        let passwordIcon: UIImageView = UIImageView(image: UIImage.bundledImage("password_placeholder_icon"))
        passwordContainer.addSubview(passwordIcon)
        passwordIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(5)
            make.centerY.equalTo(passwordContainer)
        }
        
        /// 密码输入框
        passwordInput = UITextField()
        passwordInput.text = "1111"
        passwordInput.textColor = .black
        passwordInput.placeholder = "密码"
        passwordInput.isSecureTextEntry = true
        passwordInput.backgroundColor = .white
        passwordContainer.addSubview(passwordInput)
        passwordInput.snp.makeConstraints { (make) in
            make.left.equalTo(passwordIcon.snp_rightMargin).offset(15)
            make.top.height.equalTo(passwordContainer)
            make.right.equalTo(-40)
        }
        
        /// 密码明文密文按钮
        passwordSecurity = UIImageView(image: UIImage.bundledImage("visible_placeholder_icon"))
        passwordSecurity.isUserInteractionEnabled = true
        let passwordTap = UITapGestureRecognizer(target: self, action: #selector(passwordDeleteTapAction))
        passwordSecurity.addGestureRecognizer(passwordTap)
        passwordContainer.addSubview(passwordSecurity)
        passwordSecurity.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(passwordInput.snp_rightMargin).offset(10)
            make.centerY.equalTo(passwordContainer)
        }
        
        /// 忘记密码
        let forgetPasswordButton: UIButton = UIButton()
        forgetPasswordButton.setTitle("忘记密码", for: .normal)
        forgetPasswordButton.titleLabel?.font = .systemFont(ofSize: 14)
        forgetPasswordButton.setTitleColor(UIColor(hex: "#778899"), for: .normal)
        forgetPasswordButton.setTitleColor(UIColor(hex: "#772299"), for: .highlighted)
        forgetPasswordButton.addTarget(self, action: #selector(forgetButtonAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(forgetPasswordButton)
        forgetPasswordButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordContainer.snp_bottomMargin).offset(20)
            make.height.equalTo(20)
            make.left.equalTo(passwordContainer).offset(20)
        }
        
        /// 登录按钮
        let loginButton: UIButton = UIButton()
        loginButton.setTitle("登录", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 22)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(UIColor(hex: "#772299"), for: .highlighted)
        loginButton.addTarget(self, action: #selector(loginButtonAction(_:)), for: .touchUpInside)
        loginButton.backgroundColor = UIColor(hex: "#5B8CF2")
        loginButton.layer.cornerRadius = 22
        
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(forgetPasswordButton.snp_bottomMargin).offset(40)
            make.height.equalTo(44)
            make.width.equalTo(240)
            make.centerX.equalTo(self.view)
        }
        
        /// 注册按钮
        let registerButton: UIButton = UIButton()
        registerButton.setTitle("去注册", for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 16)
        registerButton.setTitleColor(UIColor(hex: "#5B8CF2"), for: .normal)
        registerButton.setTitleColor(UIColor(hex: "#5B8Cc2"), for: .highlighted)
        registerButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp_bottomMargin).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(240)
            make.centerX.equalTo(self.view)
        }
        
        /// 底部图片
        let bottomImageView: UIImageView = UIImageView(image: UIImage.bundledImage("login_background_down"))
        self.view.addSubview(bottomImageView)
        bottomImageView.snp.makeConstraints { (make) in
            make.left.bottom.width.equalTo(self.view)
            make.height.equalTo(160)
        }
    }
    
    /// 清空按钮点击回调
    @objc func accountDeleteTapAction() -> Void {
        print("点击了account delete")
        accountInput.text = ""
    }
    
    
    /// 密码明文/密文切换
    @objc func passwordDeleteTapAction() -> Void {
        print("点击了password")
        passwordInput.isSecureTextEntry = !passwordInput.isSecureTextEntry;
        passwordSecurity.image = UIImage.bundledImage(passwordInput.isSecureTextEntry ? "visible_placeholder_icon" : "invisible_placeholder_icon")
    }
    
    /// 忘记密码按钮点击事件
    @objc func forgetButtonAction(_ button: UIButton) -> Void {
        print("忘记密码被点击")
        let forgetPasswordVC: MTTForgetPasswordViewController = MTTForgetPasswordViewController()
        forgetPasswordVC.modalPresentationStyle = .fullScreen
        present(forgetPasswordVC, animated: true) {
            
        }
    }
    
    /// 登录按钮点击事件
    @objc func loginButtonAction(_ button: UIButton) -> Void {
        print("登录被点击")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginAction"), object: [
            "username": accountInput.text,
            "password": passwordInput.text
        ])
        
    }

    
    /// 注册按钮点击事件
    @objc func registerButtonAction(_ button: UIButton) -> Void {
        print("注册被点击")
        let registerVC: MTTRegisterViewController = MTTRegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true) {
            
        }
    }
}
