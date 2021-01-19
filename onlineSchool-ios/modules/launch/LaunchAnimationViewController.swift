//
//  LaunchAnimationViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/19.
//

import UIKit
import Lottie
/**
 * description: 启动动画控制
 *
 * author: waitwalker
 */
class LaunchAnimationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lottieAnimationView:AnimationView = AnimationView(name: "launch")
        lottieAnimationView.contentMode = .scaleAspectFill
        lottieAnimationView.loopMode = .playOnce
        lottieAnimationView.isUserInteractionEnabled = true
        lottieAnimationView.backgroundBehavior = .pauseAndRestore
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        lottieAnimationView.addGestureRecognizer(tap)
        self.view.addSubview(lottieAnimationView)
        lottieAnimationView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.view)
        }
        lottieAnimationView.play { (value) in
            print("动画播放完成状态:\(value)")
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false) {
                
            }
        }
        

        
    }
    
    /// lottie动画点击事件
    @objc func tapAction() -> Void {
        print("点击动画了")
    }

}
