//
//  LaunchAnimationViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/19.
//

import UIKit

/**
 * description: 启动动画控制
 *
 * author: waitwalker
 */
class LaunchAnimationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tmpView = UIView()
        tmpView.backgroundColor = .brown
        self.view.addSubview(tmpView)
        
        tmpView.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(300)
            make.center.equalTo(self.view)
            
        }
        
        
    }
    

}
