//
//  LaunchAnimationViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/19.
//

import UIKit

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
