//
//  LaunchAnimationViewController.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/19.
//

import UIKit
import Lottie
import URLNavigator

/**
 * description: 启动动画控制
 *
 * author: waitwalker
 */
class LaunchAnimationViewController: BaseViewController {
    
    private let navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 启动动画
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
            self.navigator.present("navigator://loginModule")
        }
        
    }
    
    /// lottie动画点击事件
    @objc func tapAction() -> Void {
        print("点击动画了")
    }

}
