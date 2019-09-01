//
//  TickMarkSlider.swift
//  MartHoliday
//
//  Created by YOUTH2 on 21/07/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import UIKit

protocol TickMarkSliderDelegate {
    func valueChanged(_ sender: UISlider)
}

class TickMarkSlider: UISlider {

    var numberOfTickMarks: Float?
    var unit: Float?
    var delegate: TickMarkSliderDelegate?

    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)

    convenience init(tick: Float, minimumValue: Float, maximumValue: Float, initialValue: Float, frame: CGRect) {
        self.init(frame: frame)
        self.numberOfTickMarks = tick
        self.unit = (maximumValue - self.minimumValue) / tick
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.value = initialValue
        self.minimumTrackTintColor = UIColor.appColor(color: .mint)
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addTickMarks() {
        let width: CGFloat = 2.0
        let height: CGFloat = 15.0
        let yPosition: CGFloat = (self.frame.size.height - 13)/2
        var xPosition: CGFloat = 0

        guard let numberOfTickMarks = self.numberOfTickMarks else { return }
        let ratio = Float(self.frame.width) / numberOfTickMarks

        for i in 0..<Int(numberOfTickMarks) {
            if i == 0 {
                xPosition += width
                continue
            }

            xPosition = CGFloat(Float(i) * ratio)

            let tick = UIView(frame: CGRect(x: xPosition, y: yPosition, width: width, height: height))
            tick.backgroundColor = .gray

            self.insertSubview(tick, belowSubview: self)
            xPosition += width
        }
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let unit = self.unit else { return }

        let newStep = roundf(self.value / unit)
        self.value = newStep * unit
        self.delegate?.valueChanged(self)
        hapticGenerator.impactOccurred()

        let adjustValue: Float = self.value > 4 ? 0.3 : 0
        self.value = (newStep * unit) + adjustValue
    }

}
