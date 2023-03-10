//
//  BaseViewController.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 10/03/23.
//

import UIKit
import NVActivityIndicatorView

class BaseVC: UIViewController {

    var activityIndicatorView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    /// show loader
    func showActivityIndicator() {
        let size = CGSize(width: 50, height:50)
        let frame = CGRect(origin: CGPoint(x: 3, y: 3), size: size)
        hideActivityIndicator()
        activityIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        activityIndicatorView?.backgroundColor = UIColor.clear
        activityIndicatorView?.layer.cornerRadius = 28

        activityIndicatorView?.center = self.view.center
        let nvActivityView = NVActivityIndicatorView(frame: frame, type: .ballScaleMultiple, color: UIColor.gray, padding: nil )
        self.activityIndicatorView?.addSubview(nvActivityView)
        nvActivityView.startAnimating()
        guard let loader = activityIndicatorView else { return }
        self.view.addSubview(loader)
    }
    
    
    /// hide loader
    func hideActivityIndicator() {
        self.activityIndicatorView?.removeFromSuperview()
        self.activityIndicatorView = nil
    }
}
