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
    
    var menudata = [Location]()
    let cellReuseIdentifier = "menuCell"
    var filteredLocations = [Location]()
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
    }
    
    func populateMenuData() {
        locationController?.fetchItems(completion: { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if !success {
                strongSelf.locationController?.fetchItemsFromStorage(completion: { (success, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            strongSelf.tableView?.reloadData()
                        }
                    }
                })
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
        return locationController!.itemCount
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ARViewController") as? ARViewController {
            vc.destinationLocation = locationController?.item(at: indexPath.row)
            present(vc, animated: true, completion: nil)
        }
    }
}
