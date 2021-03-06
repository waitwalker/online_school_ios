//
//  MTTForgetPasswordViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/25.
//

import UIKit
import SnapKit

@available(iOS 13.0, *)
public class MTTForgetPasswordViewController: UIViewController {

    var accountInput: UITextField!
    var codeInput: UITextField!
    var getCodeButton: UIButton!
    var passwordInput: UITextField!
    var passwordSecurity: UIImageView!
    var count : Int?
    var enabled : Bool?
    var timer : Timer?
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        /// 返回按钮
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage.bundledImage("forget_password_back_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(bactButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(80)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
        
        /// 顶部图片
        let topImageView: UIImageView = UIImageView(image: UIImage.bundledImage("login_background_top"))
        self.view.addSubview(topImageView)
        topImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(160)
        }
        
        /// 忘记密码
        let forgetPasswordLabel: UILabel = UILabel()
        forgetPasswordLabel.text = "忘记密码"
        forgetPasswordLabel.textColor = .black
        forgetPasswordLabel.textAlignment = .left
        forgetPasswordLabel.font = .systemFont(ofSize: 22, weight: .bold)
        self.view.addSubview(forgetPasswordLabel)
        forgetPasswordLabel.snp.makeConstraints { (make) in
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
            make.top.equalTo(forgetPasswordLabel.snp_bottomMargin).offset(60)
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
        accountInput.textColor = .black
        accountInput.placeholder = "手机号"
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
        
        /// 验证码容器
        let codeContainer: UIView = UIView()
        codeContainer.backgroundColor = .white
        codeContainer.layer.cornerRadius = 20
        codeContainer.layer.shadowOpacity = 0.7
        codeContainer.layer.shadowRadius = 10
        codeContainer.layer.shadowColor = UIColor.gray.cgColor
        codeContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.view.addSubview(codeContainer)
        
        codeContainer.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(accountContainer.snp_bottomMargin).offset(40)
            make.height.equalTo(44)
        }
        
        /// 账号图标
        let codeIcon: UIImageView = UIImageView(image: UIImage.bundledImage("code_placeholder_iconx"))
        codeContainer.addSubview(codeIcon)
        codeIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(5)
            make.centerY.equalTo(codeContainer)
        }
        
        /// 验证码输入框
        codeInput = UITextField()
        codeInput.textColor = .black
        codeInput.placeholder = "验证码"
        codeInput.backgroundColor = .white
        codeContainer.addSubview(codeInput)
        codeInput.snp.makeConstraints { (make) in
            make.left.equalTo(codeIcon.snp_rightMargin).offset(15)
            make.top.height.equalTo(codeContainer)
            make.right.equalTo(-100)
        }
        
        
        /// 获取验证码
        getCodeButton = UIButton()
        getCodeButton.setTitle("获取验证码", for: .normal)
        getCodeButton.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        getCodeButton.setTitleColor(UIColor(hex: "#888888"), for: .highlighted)
        getCodeButton.titleLabel?.font = .systemFont(ofSize: 13)
        getCodeButton.addTarget(self, action: #selector(codeButtonAction(_:)), for: .touchUpInside)
        codeContainer.addSubview(getCodeButton)
        getCodeButton.snp.makeConstraints { (make) in
            make.left.equalTo(codeInput.snp.rightMargin).offset(5)
            make.height.right.top.equalTo(codeContainer)
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
            make.top.equalTo(codeContainer.snp_bottomMargin).offset(40)
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
        
        
        /// 登录按钮
        let loginButton: UIButton = UIButton()
        loginButton.setTitle("登录", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 22)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(UIColor(hex: "#772299"), for: .highlighted)
        loginButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        loginButton.backgroundColor = UIColor(hex: "#5B8CF2")
        loginButton.layer.cornerRadius = 22
        
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordContainer.snp_bottomMargin).offset(80)
            make.height.equalTo(44)
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
    
    
    /// 返回按钮点击事件
    @objc func bactButtonAction(_ button: UIButton) -> Void {
        dismiss(animated: true) {
            
        }
    }
    
    
    /// 清空按钮点击回调
    @objc func accountDeleteTapAction() -> Void {
        print("点击了account delete")
        accountInput.text = ""
    }
    
    
    /// 获取验证码按钮点击事件
    @objc func codeButtonAction(_ button: UIButton) -> Void {
        print("获取验证码按钮被点击")
        startCountDown(timeout: 60)
    }
    
    /// 开启倒计时
    private func startCountDown(timeout: Int) {
        // 倒计时时间
        self.count = timeout
        self.getCodeButton.isEnabled = false
            
        // 加一个计时器
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc func timerFired() {
        if self.count != 1 {
            self.count! -= 1
            self.getCodeButton.isEnabled = false
            self.getCodeButton.setTitle("\(self.count!)s后重试", for: UIControl.State.normal)
        } else {
            self.getCodeButton.isEnabled = true
            self.getCodeButton.setTitle("获取验证码", for: UIControl.State.normal)
            // 放开按钮点击权限，可以再次点击
            self.getCodeButton.isEnabled = true
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    /// 密码明文/密文切换
    @objc func passwordDeleteTapAction() -> Void {
        print("点击了password")
        passwordInput.isSecureTextEntry = !passwordInput.isSecureTextEntry;
        passwordSecurity.image = UIImage.bundledImage(passwordInput.isSecureTextEntry ? "visible_placeholder_icon" : "invisible_placeholder_icon")
    }
    
    
    /// 登录按钮点击事件
    @objc func loginButtonAction(_ button: UIButton) -> Void {
        print("登录被点击")
    }

    
    /// 注册按钮点击事件
    @objc func registerButtonAction(_ button: UIButton) -> Void {
        print("注册被点击")
    }
}
