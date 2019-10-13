//
//  SettingFavoriteListViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 04/09/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import UIKit

protocol FavoriteListEditor {
    func finishEditing()
}


class SettingFavoriteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var delegate: FavoriteListEditor?
    var favoriteBranches: [FavoriteBranch]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
    }

    func finish() {
        delegate?.finishEditing()
    }

    
}

extension SettingFavoriteListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoriteList.shared().count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        cell.name = favoriteBranches?[indexPath.row].branchName()

        return cell

    }



}
