//
//  ModuleActionManager.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/2/4.
//

import Foundation
import NetworkLibrary
import Toaster
import URLNavigator

class ModuleActionManager: NSObject {
    
    static let sharedInstance = ModuleActionManager()
    
    private override init() {
        
    }
    var navigator: Navigator!
    /// 注册监听
    func registerAction(navigator: Navigator) -> Void {
        self.navigator = navigator
        /// 登录按钮点击事件
        NotificationCenter.default.addObserver(self, selector: #selector(loginAction(notification:)), name: NSNotification.Name(rawValue: "LoginAction"), object: nil)
        
        /// 注册按钮点击事件
        NotificationCenter.default.addObserver(self, selector: #selector(registerAction(notification:)), name: NSNotification.Name(rawValue: "RegisterAction"), object: nil)
        
        /// 用户协议按钮点击事件
        NotificationCenter.default.addObserver(self, selector: #selector(userAgreementAction(notification:)), name: NSNotification.Name(rawValue: "UserAgreementAction"), object: nil)
    }
    
    /// 登录点击事件
    @objc func loginAction(notification: Notification) -> Void {
        print("登录事件")
        let parameter: Dictionary = notification.object as! Dictionary<String, String>
        if let account = parameter["username"], let password = parameter["password"] {
            if account.count > 0 && password.count > 0 {
                MTTLoadingManager.sharedInstance.startAnimating()
                NetworkManager.sharedInstance.postRequest(ApiConst.login, parameters: ["username" : account, "password" : password]) { (model) in
                    if (model.code > 0) {
                        let loginModel = model as! LoginModel
                        if loginModel.code == 1 {
                            NetworkManager.sharedInstance.bearerToken = loginModel.access_token
                            /// 登录成功
                            /// 获取窗口&切换rootViewController
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = MTTTabBarController(navigator: self.navigator)
                                window.makeKeyAndVisible()
                                print("window:\(window)")
                            } else {
                                print("window is none")
                            }
                        } else {
                            Toast(text: loginModel.msg).show()
                        }
                        MTTLoadingManager.sharedInstance.stopAnimating()
                    } else {
                        print("错误码:\(model.code); 错误信息:\(model.msg)")
                        NetworkManager.sharedInstance.bearerToken = ""
                        /// 登录失败
                        MTTLoadingManager.sharedInstance.stopAnimating()
                        Toast(text: "登录失败请重试").show()
                    }
                    /// 缓存token
                    UserDefaults.standard.set(NetworkManager.sharedInstance.bearerToken, forKey: "token")
                }
            } else {
                /// 请输入用户名或密码
                Toast(text: "请输入用户名或密码").show()
            }
            
        } else {
            /// 请输入用户名或密码
            Toast(text: "请输入用户名或密码").show()
        }
        
    }
    
    /// 注册点击事件
    @objc func registerAction(notification: Notification) -> Void {
        print("注册事件")
        let parameter: Dictionary = notification.object as! Dictionary<String, String>
        if let account = parameter["username"], let password = parameter["password"], let code = parameter["code"], let area = parameter["area"] {
            if account.count > 0 && password.count > 0 {
                MTTLoadingManager.sharedInstance.startAnimating()
                NetworkManager.sharedInstance.postRequest(ApiConst.register,
                                                          parameters:
                                                            ["mobile" : account,
                                                             "password" : password,
                                                             "phoneCode" : code,
                                                             "province" : area,
                                                             "city" : area,
                                                             "regionId" : area]
                ) { (model) in
                    if (model.code > 0) {
                        let registerModel = model as! RegisterModel
                        if registerModel.code == 1 {
                            Toast(text: registerModel.msg).show()
                        } else {
                            Toast(text: registerModel.msg).show()
                        }
                        MTTLoadingManager.sharedInstance.stopAnimating()
                        
                    } else {
                        print("错误码:\(model.code); 错误信息:\(model.msg)")
                        NetworkManager.sharedInstance.bearerToken = ""
                        /// 登录失败
                        MTTLoadingManager.sharedInstance.stopAnimating()
                        Toast(text: "注册失败请重试").show()
                    }
                    
                }
            } else {
                /// 请输入用户名或密码
                Toast(text: "请输入完整信息").show()
            }
            
        } else {
            /// 请输入用户名或密码
            Toast(text: "请输入完整信息").show()
        }
    }
    
    /// 用户协议
    @objc func userAgreementAction(notification: Notification) -> Void {
        self.navigator.present("navigator://userAgreementAction")
    }
}
