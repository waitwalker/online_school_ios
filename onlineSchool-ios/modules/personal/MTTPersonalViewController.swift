//
//  MTTPersonalViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/25.
//

/// 个人中心

import UIKit

class MTTPersonalViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 100, y: 300, width: 200, height: 70))
        button.setTitle("退出", for: .normal)
        button.backgroundColor = .brown
        button.addTarget(self, action: #selector(touchAction), for: .touchUpInside)
        self.view.addSubview(button)
        
    }
    
    @objc func touchAction() -> Void {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = LoginViewController()
            window.makeKeyAndVisible()
            print("window:\(window)")
        } else {
            print("window is none")
        }
    }

}
