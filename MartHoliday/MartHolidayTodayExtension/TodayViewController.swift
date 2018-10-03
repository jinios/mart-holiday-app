//
//  TodayViewController.swift
//  MartHolidayTodayExtension
//
//  Created by YOUTH2 on 2018. 9. 14..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 36.0
        setFavoriteBranch(handler: reloadTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        self.tableView.reloadData()
        completionHandler(NCUpdateResult.newData)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = (activeDisplayMode == .expanded)
        let count = CGFloat(favoriteList.count())
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: (tableView.rowHeight * count)) : maxSize
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.reloadData()
    }

    var favoriteList = BranchList()
    private let appGroup = UserDefaults.init(suiteName: "group.jinios.martholiday")

    func getFavorites() -> [Int] {
        guard let result = appGroup?.value(forKey: "favorites") as? [Int] else { return [1] }
        return result
    }

    func setFavoriteBranch(handler: @escaping (() -> Void)) {
        let ids = getFavorites()
        let idstr = ids.map{String($0)}.joined(separator: ",")
        guard let baseURL = URL(string: "http://ec2-13-209-38-224.ap-northeast-2.compute.amazonaws.com/api/mart/branch") else { return }
        let url = baseURL.appendingPathComponent(idstr)

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                var branches = [BranchRawData]()
                do {
                    branches = try JSONDecoder().decode([BranchRawData].self, from: data)
                    self.favoriteList = BranchList(branches: branches)
                    handler()
                } catch let error {
                    print("Cannot make Data: \(error)")
                }
            } else {
                print("Network error: \((response as? HTTPURLResponse)?.statusCode)")
            }
            }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteList.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayExCell", for: indexPath) as? TodayExtensionTableViewCell else { return UITableViewCell() }
        cell.setData(branch: self.favoriteList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: "openApp:") else { return }
        self.extensionContext?.open(url, completionHandler: nil)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

}
