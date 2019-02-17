//
//  NoMapView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 10. 2..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import Toaster

protocol AddressCopiable {
    var noMapView: UIView? { get }
    func copyAddress()
}

class NoMapView: UIView {

    @IBOutlet var contentView: UIView!
    var delegate: AddressCopiable!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromXib()
    }

    private func loadFromXib() {
        Bundle.main.loadNibNamed("NoMapView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    @IBAction func copyButtonTapped(_ sender: Any) {
        let toast = Toast(text: ProgramDescription.AddressCopiedToastMessage.rawValue, duration: Delay.long)
        delegate.copyAddress()
        toast.show()
    }

}


