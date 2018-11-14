//
//  LocationController.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 25/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation
import CoreData

typealias FetchItemsCompletionBlock = (_ success: Bool, _ error: NSError?) -> Void

protocol LocationControllerDelegate {
    var items: [LocationViewModel?]? { get }
    var itemCount: Int { get }
    
    func item(at index: Int) -> LocationViewModel?
    func fetchItems(completion: @escaping FetchItemsCompletionBlock)
    func fetchItemsFromStorage(completion: @escaping FetchItemsCompletionBlock)
}

extension LocationControllerDelegate {
    var items: [LocationViewModel?]? {
        return items
    }
    
    var itemCount: Int {
        return items?.count ?? 0
    }
    
    func item(at index: Int) -> LocationViewModel? {
        guard index >= 0 && index < itemCount else { return nil }
        return items?[index] ?? nil
    }
    
}

class LocationController: LocationControllerDelegate {
    func fetchItemsFromStorage(completion: @escaping FetchItemsCompletionBlock) {
        fetchItemsCompletionBlock = completion
        if let locations = self.fetchFromStorage() {
            let newLocations = LocationController.initViewModels(locations)
            self.items?.append(contentsOf: newLocations)
            DispatchQueue.main.async {
                self.fetchItemsCompletionBlock?(true, nil)
            }
        }
    }
    
    func item(at index: Int) -> LocationViewModel? {
        guard index >= 0 && index < itemCount else { return nil }
        return items?[index] ?? nil
    }
    
    func fetchItems(completion: @escaping FetchItemsCompletionBlock) {
        fetchItemsCompletionBlock = completion
        loadLocations()
    }
    
    private static let entityName = "Location"
    
    var items: [LocationViewModel?]? = []
    
    private var fetchItemsCompletionBlock: FetchItemsCompletionBlock?
    
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
}


private extension LocationController {
    
    static func initViewModels(_ locations: [Location?]) -> [LocationViewModel?] {
        return locations.map { location in
            if let location = location {
                return LocationViewModel(location: location)
            } else {
                return nil
            }
        }
    }
    
    func parse(_ jsonData: Data) -> Bool {
        do {
            guard let codingUserInfoManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve context")
            }
            
            //MARK: - Clear storage
            clearStorage()
            
            // Parse JSON data
            let managedObjectContext = persistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[codingUserInfoManagedObjectContext] = managedObjectContext
            _ = try decoder.decode([Location].self, from: jsonData)
            try managedObjectContext.save()
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    func clearStorage() {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: LocationController.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetchFromStorage() -> [Location]? {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Location>(entityName: LocationController.entityName)
        let sortDescriptor1 = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        do {
            let locatons = try managedObjectContext.fetch(fetchRequest)
            return locatons
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func loadLocations() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pwrarnavapi.herokuapp.com"
        urlComponents.path = "/api/v1/locations"
        guard let url = urlComponents.url else {
            fetchItemsCompletionBlock?(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { [weak self] (responseData, response, responseError) in
            guard let strongSelf = self else { return }
            if let error = responseError {
                DispatchQueue.main.async {
                    strongSelf.fetchItemsCompletionBlock?(false, error as NSError?)
                }
            } else if let jsonData = responseData {
                if strongSelf.parse(jsonData) {
                    if let locations = strongSelf.fetchFromStorage() {
                        let newLocations = LocationController.initViewModels(locations) 
                        strongSelf.items?.append(contentsOf: newLocations)
                        DispatchQueue.main.async {
                            strongSelf.fetchItemsCompletionBlock?(true, nil)
                        }
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from the request"]) as Error
                    DispatchQueue.main.async {
                        strongSelf.fetchItemsCompletionBlock?(false, error as NSError?)
                    }
                }
            }
        }
        task.resume()
    }
}
