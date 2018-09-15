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
        setFavoriteBranch(handler: reloadTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.tableView.reloadData()
        completionHandler(NCUpdateResult.newData)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = (activeDisplayMode == .expanded)
        print(maxSize)
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }

    // After updating the preferred size, you must reload the chart’s data so that it redraws based on the new layout.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.reloadData()
    }

    var favoriteList = BranchList()

    func setFavoriteBranch(handler: @escaping (() -> Void)) {
        let ids = [1,2,3]
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


    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

}
