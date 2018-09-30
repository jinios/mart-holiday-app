//
//  ViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 10..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MartSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.appColor(color: .lightgray)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.appColor(color: .lightgray)
        self.navigationItem.title = "마트 검색"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func pushViewController(mart: Mart, data: [BranchRawData]) {
        DispatchQueue.main.async {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as? SearchViewController else { return }
            nextVC.list = BranchList(branches: data)
            nextVC.mart = mart.koreanName
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}

extension MartSelectViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let marts = Mart.allValues
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as? SelectionTableViewCell else { return UITableViewCell() }
        let background = UIView()
        background.backgroundColor = UIColor.appColor(color: .lightgray)
        cell.selectedBackgroundView = background
        cell.data = marts[indexPath.row]
        cell.setImage()
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Mart.allValues.count
    }
}

extension MartSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let marts = Mart.allValues
        DataSetter<Mart, BranchRawData>.goToSearchViewController(of: marts[indexPath.row], handler: pushViewController(mart:data:))
    }


}
