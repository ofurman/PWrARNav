//
//  MenuController.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 17/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit
import CoreData

class MenuController: UIViewController {
    
    var menudata = [LocationViewModel]()
    let cellReuseIdentifier = "menuCell"
    var filteredLocations = [LocationViewModel]()
    let searchController = UISearchController(searchResultsController: nil)
    
    private var locationController: LocationControllerDelegate?
    
    
    @IBOutlet weak var tableView: UITableView?
    
    public static func create(persistentContainer: NSPersistentContainer) -> MenuController {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let menuController = storyboard.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        let locationController = LocationController(persistentContainer: persistentContainer)
        menuController.locationController = locationController
        return menuController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateMenuData()
        initializeTableView()
        //        setUpSearchController()
        
        
        // Do any additional setup after loading the view.
    }
    
    func populateMenuData() {
        locationController?.fetchItems(completion: { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if !success {
                DispatchQueue.main.async {
                    if let error = error {
                        print(error)
                    } else {
                        print(error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.tableView?.reloadData()
                }
            }
            
        })
    }
}

//MARK: - Table View
extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationController?.itemCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.tableView?.dequeueReusableCell(withIdentifier: cellReuseIdentifier))!
        cell.textLabel?.text = locationController?.item(at: indexPath.row)?.name
        return cell
    }
    
    
    func initializeTableView() {
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        if isFiltering() {
    //            return self.filteredLocations.count
    //        }
    //        return self.menudata.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = (self.tableView?.dequeueReusableCell(withIdentifier: cellReuseIdentifier))!
    //        let locationName: String
    //        if isFiltering() {
    //            locationName = filteredLocations[indexPath.row].name
    //        } else {
    //            locationName = menudata[indexPath.row].name
    //        }
    //        cell.textLabel?.text = locationName
    //        return cell
    //    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
    //        self.navigationController?.pushViewController(vc!, animated: true)
    //    }
    
}

//MARK: - SearchBar
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
            return menuitem.name.lowercased().contains(searchText.lowercased())
        })

        tableView?.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

