//
//  MTTTabBarController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/25.
//

/// controller 容器

import UIKit

class MTTTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewController()
    }
    
    /// 设置子控制器
    private func setupSubviewController() -> Void {
        let homeVC            = MTTHomeViewController()
        addChildViewControllers(homeVC, normalIcon: UIImage(named: "tabbar_item_my_course_normal")!, selectedIcon: UIImage(named: "tabbar_item_my_course_selected")!, tabBarTitle: "我的课程")
        let personalVC        = MTTPersonalViewController()
        addChildViewControllers(personalVC, normalIcon: UIImage(named: "tabbar_item_personal_center_normal")!, selectedIcon: UIImage(named: "tabbar_item_personal_center_selected")!, tabBarTitle: "个人中心")
    }
    
    /// 子控制器相关属性初始化
    private func addChildViewControllers(_ childViewController: BaseViewController, normalIcon: UIImage, selectedIcon: UIImage, tabBarTitle: String) -> Void {
        
        childViewController.tabBarItem.title         = tabBarTitle
        childViewController.tabBarItem.imageInsets   = UIEdgeInsets(top: 0, left: 2, bottom: -0, right: -2)
        childViewController.tabBarItem.image         = normalIcon
        childViewController.tabBarItem.selectedImage = selectedIcon
        childViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: "#B0BACB")], for: .normal)
        childViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: "#2E96FF")], for: .selected)
        let navigationController                     = MTTNavigationController(rootViewController: childViewController)
        self.addChild(navigationController)
        
    }
    
    

}
