//
//  DetailViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var mapview: UIView!
    @IBOutlet weak var martTitle: UILabel!
    @IBOutlet weak var holidayStackView: UIStackView!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var phoneCallButton: UIButton!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var starIcon: UIButton!

    var branchData: Branch?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setTitle()
        setAddress()
        setHolidays()
        setPhoneNumber()
        setStarIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setNavigationItem() {
        guard let branchData = self.branchData else { return }
        self.navigationItem.title = branchData.branchName
    }

    private func setTitle() {
        guard let branchData = self.branchData else { return }
        self.martTitle.text = branchData.branchName
    }

    private func setHolidays() {
        guard let branchData = self.branchData else { return }
        branchData.holidays.forEach { holiday in
            let label = UILabel(frame: CGRect.zero)
            label.font = label.font.withSize(12.0)
            label.textColor = UIColor.blue
            label.text = holiday
            self.holidayStackView.addArrangedSubview(label)
        }
    }

    private func setPhoneNumber() {
        guard let branchData = self.branchData else { return }
        self.phoneNumberLabel.text = branchData.phoneNumber
    }

    private func setAddress() {
        guard let branchData = self.branchData else { return }
        address.text = branchData.address
    }

    @IBAction func goToWebPage(_ sender: Any) {
        guard let branchData = self.branchData else { return }
        guard let url = URL(string: branchData.url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
    }

    @IBAction func phoneCallTapped(_ sender: Any) {
        guard let branchData = self.branchData else { return }
        let phoneNumber = branchData.phoneNumber.filter { $0 != Character(" ") && $0 != Character("-") }
        if let phoneNumberURL = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(phoneNumberURL, options: [:]) { (success) in
                if success {
                    print("call")
                } else  {
                    print("fail")
                }

            }
        }
    }

    @IBAction func favoriteTapped(_ sender: Any) {
        guard let branchData = self.branchData else { return }
        guard branchData.toggleFavorite() else { return }
        starIcon.toggleSelectedState()
    }

    private func setStarIcon() {
        guard let branchData = self.branchData else { return }
        starIcon.isSelected = branchData.favorite
        starIcon.setStarIconImage()
    }

}

