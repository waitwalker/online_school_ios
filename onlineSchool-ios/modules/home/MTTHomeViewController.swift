//
//  MTTHomeViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/25.
//

/// 主页

import UIKit
import NetworkLibrary

class MTTHomeViewController: BaseViewController {
    
    var zhiLingContainerView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.sharedInstance.getRequest(ApiConst.home_course, parameters: nil) { (model) in
            
            print("\(model)")
            
        }
        
    }
    

}
