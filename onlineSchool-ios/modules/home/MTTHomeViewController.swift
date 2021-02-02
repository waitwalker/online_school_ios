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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        zhiLingContainerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 300))
        zhiLingContainerView.backgroundColor = UIColor(hex: "#3399ff")
        self.view.addSubview(zhiLingContainerView)
        
        let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 15
        collectionViewFlowLayout.minimumLineSpacing = 50
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.w, height: 300), collectionViewLayout: collectionViewFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        zhiLingContainerView.addSubview(collectionView)
        
        
//        NetworkManager.sharedInstance.getRequest(ApiConst.home_course, parameters: nil) { (model) in
//
//            print("\(model)")
//
//        }
        
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
        
    }
    
    
}

extension MTTHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

