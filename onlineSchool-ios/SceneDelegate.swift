//
//  SceneDelegate.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/19.
//

import UIKit
import URLNavigator
import NetworkLibrary
import Toaster


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    private var navigator: Navigator?

    /// 和didFinish功能类似
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let navigator = Navigator()
        NavigationMap.initialize(navigator: navigator)
        self.navigator = navigator
        if let windowScene = scene as? UIWindowScene {
            let wind = UIWindow(windowScene: windowScene)
            let launchController = LaunchAnimationViewController(navigator: navigator)
            wind.rootViewController = launchController
            self.window = wind
            self.window?.makeKeyAndVisible()
        }
        
        /// 监听事件
        /// 登录按钮点击事件
        ModuleActionManager.sharedInstance.registerAction(navigator: navigator)
        NotificationCenter.default.addObserver(self, selector: #selector(loginAction(notification:)), name: NSNotification.Name(rawValue: "LoginAction"), object: nil)

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
                                window.rootViewController = MTTTabBarController()
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
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


    deinit {
        /// 移除监听
        NotificationCenter.default.removeObserver(self)
    }
    
}

