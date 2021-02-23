//
//  MTTHomeCardContainerView.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/2/18.
//

import UIKit
import NetworkLibrary
import URLNavigator

/// 首页卡片容器 智领&智学课用到

class MTTHomeCardContainerView: UIView {
    
    var collectionView: UICollectionView!
    let reusedId: String = "reusedId"
    
    var navigator: Navigator?
    

    var dataSource: [HomeCourseDataModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 便利构造器
    convenience init(frame: CGRect, navigator: Navigator) {
        self.init(frame: frame)
        self.navigator = navigator
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 15
        collectionViewFlowLayout.minimumLineSpacing = 15
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MTTHomeCollectionViewCell.self, forCellWithReuseIdentifier: reusedId)
        self.addSubview(collectionView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

extension MTTHomeCardContainerView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedId, for: indexPath) as! MTTHomeCollectionViewCell
        
        if let data = self.dataSource {
            cell.setDataSource(data[indexPath.item], navigator: self.navigator!, index: indexPath.row, dataSources: data)
        }
        return cell
    }
}

extension MTTHomeCardContainerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MTTHomeCardContainerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (self.w - 20 * 2 - 20) / 2
        let height: CGFloat = width * 2 / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
}


