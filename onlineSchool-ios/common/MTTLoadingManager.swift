//
//  MTTLoadingManager.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/29.
//

import UIKit
import NVActivityIndicatorView
import Toaster

class MTTLoadingManager: NSObject {
    
    private var indicator: NVActivityIndicatorView!
    
    static let sharedInstance = MTTLoadingManager()
    
    private override init() {
        indicator = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width - 80 ) / 2.0, y: (UIScreen.main.bounds.size.height - 80 ) / 2.0, width: 80, height: 80), type: .ballSpinFadeLoader, color: .darkGray, padding: 20)
        if let window = UIApplication.shared.windows.first {
            window.addSubview(indicator)
            print("window:\(window)")
        } else {
            Toast(text: "window获取失败").show()
        }
    }
    
    func startAnimating() -> Void {
        indicator.startAnimating()
    }
    
    func stopAnimating() -> Void {
        indicator.stopAnimating()
    }

}
