//
//  BrowseWebviewController.swift
//  
//
//  Created by waitwalker on 2021/1/27.
//

import UIKit

public class BrowseWebviewController: UIViewController {
    
    /// URL链接
    private var url: String! = ""
    /// 导航栏标题
    private var navTitle: String?
    /// 构造函数
    public convenience init(_ url: String, title: String?) {
        self.init()
        self.url = url
        self.navTitle = title
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        print("url:\(url!)")
    }
}
