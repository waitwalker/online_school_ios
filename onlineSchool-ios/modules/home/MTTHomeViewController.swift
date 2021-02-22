//
//  MTTHomeViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/25.
//

/// 主页

import UIKit
import NetworkLibrary
import URLNavigator

class MTTHomeViewController: BaseViewController {
    
    var zhiLingContainerView: MTTHomeCardContainerView!
    var zhiLingDataSource: [HomeCourseDataModel] = []
    var zhiXueDataSource: [HomeCourseDataModel] = []
    var navigator: Navigator?
    
    
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        let statusBarHeight: CGFloat = (UIApplication.shared.windows.first?.windowScene?.statusBarManager!.statusBarFrame.size.height)!
        
        let sectionContainer: MTTSectionTitleView = MTTSectionTitleView(CGRect(x: 0, y: navigationBarHeight + statusBarHeight + 20, width: self.view.w, height: 20), title: "智领课")
        self.view.addSubview(sectionContainer)
        
        
        
        let width: CGFloat = (self.view.w - 20 * 2 - 20) / 2
        let itemHeight: CGFloat = width * 2 / 3
        
        
        let collectionViewHeight: CGFloat = itemHeight * 2 + navigationBarHeight + statusBarHeight + 20 + 15 + 10;
        
        zhiLingContainerView = MTTHomeCardContainerView(frame: CGRect(x: 0, y: sectionContainer.frame.maxY, width: self.view.bounds.size.width, height: collectionViewHeight), navigator: self.navigator!)
        zhiLingContainerView.backgroundColor = UIColor(hex: "#3399ff")
        self.view.addSubview(zhiLingContainerView)
        
        
        NetworkManager.sharedInstance.getRequest(ApiConst.home_course, parameters: nil) { (model) in

            print("\(model)")
            let homeModel: HomeCourseModel = model as! HomeCourseModel
            for(_, value) in homeModel.data.enumerated() {
                if value.subjectId == 2 || value.subjectId == 3 || value.subjectId == 4 || value.subjectId == 5 {
                    self.zhiLingDataSource.append(value)
                } else {
                    self.zhiXueDataSource.append(value)
                }
            }
            self.zhiLingContainerView.dataSource = self.zhiLingDataSource
        }
        
    }
    

}

