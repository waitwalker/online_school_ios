//
//  NavigationMap.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/2/4.
//

import Foundation
import URLNavigator
import WebviewLibrary
import LoginModule

enum NavigationMap {
    
    /// 注册路由控制器
    static func initialize(navigator: Navigator) -> Void {
        navigator.register("navigator://loginModule") { ulr, values, context in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            return loginVC
        }
        
        navigator.register("navigator://userAgreementAction") { ulr, values, context in
            let browseVC: BrowseWebviewController = BrowseWebviewController("https://www.etiantian.com/about/mobile/servandpriv.html", title: "用户协议")
            let navVC: MTTNavigationController = MTTNavigationController(rootViewController: browseVC)
            navVC.modalPresentationStyle = .fullScreen
            return navVC
        }
        
        navigator.register("navigator://subjectDetail/<model>") { ulr, values, context in
            let subjectDetail = MTTSubjectDetailViewController()
            subjectDetail.hidesBottomBarWhenPushed = true
            return subjectDetail
        }
    }
}
