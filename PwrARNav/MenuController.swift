//
//  MenuController.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 17/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    let menudata = ["C-1", "C-2", "C-3", "C-4", "C-5"]
    let cellReuseIdentifier = "menuCell"
    var filteredLocations = [String]()
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        setUpSearchController()
        

        // Do any additional setup after loading the view.
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {

    func initializeTableView() {
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.filteredLocations.count
        }
        return self.menudata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.tableView?.dequeueReusableCell(withIdentifier: cellReuseIdentifier))!
        let locationName: String
        if isFiltering() {
            locationName = filteredLocations[indexPath.row]
        } else {
            locationName = menudata[indexPath.row]
        }
        cell.textLabel?.text = locationName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped \(self.menudata[indexPath.row])")
    }
    
}

extension MenuController: UISearchResultsUpdating {
    
    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Entrance"
        searchController.searchBar.barStyle = .default
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredLocations = menudata.filter({ (menuitem) -> Bool in
            return menuitem.lowercased().contains(searchText.lowercased())
        })
        
        tableView?.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
}

