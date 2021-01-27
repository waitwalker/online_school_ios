//
//  BrowseWebviewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/27.
//

import UIKit

class InteractiveWebviewController: UIViewController {
    
    private var url: String! = ""
    private var navTitle: String?
    /// 构造函数
    convenience init(_ url: String, title: String?) {
        self.init()
        self.url = url
        self.navTitle = title
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        print("url:\(url!)")
    }
}
