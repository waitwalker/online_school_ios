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
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        zhiLingContainerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 300))
        zhiLingContainerView.backgroundColor = UIColor(hex: "#3399ff")
        self.view.addSubview(zhiLingContainerView)
        
        let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 20
        collectionViewFlowLayout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.w, height: 300), collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .green
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MTTHomeCollectionViewCell.self, forCellWithReuseIdentifier: reusedId)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedId, for: indexPath)
        return cell
    }
    
    
}

extension MTTHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MTTHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.w - 30 * 2 - 20) / 2, height: (self.view.w - 30 * 2 - 20) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
}

