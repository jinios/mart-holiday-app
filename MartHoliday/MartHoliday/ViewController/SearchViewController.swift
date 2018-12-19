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
    let searchController = UISearchController(searchResultsController: nil)

    var list: BranchList? {
        didSet {
            guard let list = self.list else { return }
            self.filtered = list
        }
    }
    var mart: String?
    var filtered: BranchList?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setNavigationBarTitle()
        tableView.rowHeight = 60.0
        setSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        tableView.reloadData()
    }

    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .default

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: ProgramDescription.TypeBranchName.rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setNavigationBarTitle() {
        guard let mart = self.mart else { return }
        self.navigationItem.title = mart
    }

    // MARK: - Private instance methods

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let filtered = list?.branches.filter({ (branch) -> Bool in
            branch.branchName.contains(searchText) || branch.address.contains(searchText)
        })
        self.filtered = BranchList(branchData: filtered!)
        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail" else { return }
        guard let nextVC = segue.destination as? DetailViewController else { return }
        if let indexPath = tableView.indexPathForSelectedRow {
            if isFiltering() {
                nextVC.branchData = filtered![indexPath.row]
            } else {
                nextVC.branchData = list![indexPath.row]
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentList = self.filtered else { return 0 }
        guard let list = self.list else { return 0 }
        guard isFiltering() else { return list.count() }
        return currentList.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let branchCell = tableView.dequeueReusableCell(withIdentifier: "branchCell", for: indexPath) as? BranchTableViewCell else { return UITableViewCell() }
        guard let list = self.list else { return UITableViewCell() }
        guard let filtered = self.filtered else { return UITableViewCell() }
        if isFiltering() {
            branchCell.branchData = filtered[indexPath.row]
        } else {
            branchCell.branchData = list[indexPath.row]
        }
        return branchCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // Called when the search bar becomes the first responder or when the user makes changes inside the search bar.
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

