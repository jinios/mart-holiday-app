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

    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        networkErrorView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 36.0
        tableView.layer.zPosition = 1
        setFavoriteBranch(handler: reloadTableView(enable:))
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
    private let appGroup = UserDefaults.init(suiteName: "group.martHoliday.com")

    private func getFavorites() -> [Int] {
        guard let result = appGroup?.value(forKey: "favorites") as? [Int] else { return [1] }
        return result
    }

    private func setFavoriteBranch(handler: @escaping ((Bool) -> Void)) {
        let ids = getFavorites()
        let idstr = ids.map{String($0)}.joined(separator: ",")

        guard let urlStr = appGroup?.value(forKey: KeyInfo.FavoriteBranchesURL.rawValue) as? String else { return }
        guard let baseURL = URL(string: urlStr) else { return }
        let url = baseURL.appendingPathComponent(idstr)

        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 3
        let session = URLSession(configuration: configure)

        session.dataTask(with: url) { [weak self] (data, response, error) in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                var branches = [BranchRawData]()
                do {
                    branches = try JSONDecoder().decode([BranchRawData].self, from: data)
                    self?.favoriteList = BranchList(branches: branches)
                    handler(true)
                } catch {
                    handler(false)
                }
            } else {
                handler(false)
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
        self.openHostApp()
    }

    @IBAction func openAppTapped(_ sender: Any) {
        self.openHostApp()
    }

    private func openHostApp() {
        guard let url = URL(string: "openApp:") else { return }
        self.extensionContext?.open(url, completionHandler: nil)
    }

    private func toggleSubViews(flag: Bool) {
        self.tableView.isHidden = !flag
        self.networkErrorView.isHidden = flag
    }
    
    private func reloadTableView(enable: Bool) {
        DispatchQueue.main.async {
            self.toggleSubViews(flag: enable)
            if enable {
                self.tableView.reloadData()
            }
        }
    }

}
