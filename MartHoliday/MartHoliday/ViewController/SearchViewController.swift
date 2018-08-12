//
//  SearchViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var list: BranchList?
    var mart: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setNavigationBarTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setNavigationBarTitle() {
        guard let mart = self.mart else { return }
        self.navigationItem.title = mart
    }

}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = self.list else { return 0 }
        return list.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let branchCell = tableView.dequeueReusableCell(withIdentifier: "branchCell", for: indexPath) as? BranchTableViewCell else { return UITableViewCell() }
        guard let list = self.list else { return UITableViewCell() }
        branchCell.branchData = list.branches[indexPath.row]
        return branchCell
    }
}
