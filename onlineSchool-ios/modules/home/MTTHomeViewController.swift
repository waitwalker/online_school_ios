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
    var collectionView: UICollectionView!
    
    let reusedId: String = "reusedId"
    
    var dataSource: [HomeCourseDataModel] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        let statusBarHeight: CGFloat = (UIApplication.shared.windows.first?.windowScene?.statusBarManager!.statusBarFrame.size.height)!
        
        let sectionContainer: MTTSectionTitleView = MTTSectionTitleView(CGRect(x: 0, y: navigationBarHeight + statusBarHeight + 20, width: self.view.w, height: 20), title: "智领课")
        self.view.addSubview(sectionContainer)
        
        
        
        let width: CGFloat = (self.view.w - 20 * 2 - 20) / 2
        let itemHeight: CGFloat = width * 2 / 3
        
        
        let collectionViewHeight: CGFloat = itemHeight * 2 + navigationBarHeight + statusBarHeight + 20 + 15 + 10;
        
        zhiLingContainerView = UIView(frame: CGRect(x: 0, y: sectionContainer.frame.maxY, width: self.view.bounds.size.width, height: collectionViewHeight))
        zhiLingContainerView.backgroundColor = UIColor(hex: "#3399ff")
        self.view.addSubview(zhiLingContainerView)
        
        let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 15
        collectionViewFlowLayout.minimumLineSpacing = 15
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.w, height: collectionViewHeight), collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MTTHomeCollectionViewCell.self, forCellWithReuseIdentifier: reusedId)
        zhiLingContainerView.addSubview(collectionView)
        
        
        NetworkManager.sharedInstance.getRequest(ApiConst.home_course, parameters: nil) { (model) in

            print("\(model)")
            let homeModel: HomeCourseModel = model as! HomeCourseModel
            for(_, value) in homeModel.data.enumerated() {
                if value.subjectId == 2 || value.subjectId == 3 || value.subjectId == 4 || value.subjectId == 5 {
                    self.dataSource.append(value)
                }
            }
            self.collectionView.reloadData()
            
        }
        
    }
    

}


extension MTTHomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedId, for: indexPath) as! MTTHomeCollectionViewCell
        if dataSource.count > 0 {
            cell.model = dataSource[indexPath.item]
        }
        return cell
    }
    
    
}

extension MTTHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MTTHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (self.view.w - 20 * 2 - 20) / 2
        let height: CGFloat = width * 2 / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
}

