//
//  NavigationMap.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/2/4.
//

import Foundation
import URLNavigator

enum NavigationMap {
    static func initialize(navigator: Navigator) -> Void {
        navigator.register("navigator://loginModule") { ulr, values, context in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            return loginVC
        }
    }
}
