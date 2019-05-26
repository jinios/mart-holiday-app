//
//  IndicatorViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 14/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class IndicatorViewController: RechabilityDetectViewController {
    var indicator: NVActivityIndicatorView!
    var indicatorBackgroundView: UIView!

    func startIndicator() {
        setIndicator()
        indicatorBackgroundView.isHidden = false
        indicator.startAnimating()
    }

    func finishIndicator() {
        indicatorBackgroundView.isHidden = true
        indicator.stopAnimating()
    }

    private func setIndicatorBackground() {
        indicatorBackgroundView = UIView(frame: self.view.bounds)
        indicatorBackgroundView.backgroundColor = UIColor.appColor(color: .lightgray)
        self.view.addSubview(indicatorBackgroundView)
        indicatorBackgroundView.isHidden = true
    }

    private func setIndicator() {
        setIndicatorBackground()
        indicator = NVActivityIndicatorView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 40, y: UIScreen.main.bounds.height/2 - 40, width: 60, height: 60), type: .circleStrokeSpin, color: UIColor.appColor(color: .lightmint))
        self.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}

