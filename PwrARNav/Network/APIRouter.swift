//
//  APIRouter.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 22/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

func getLocations(completion: ((Result<[Location]>) -> Void)?) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "pwrarnavapi.herokuapp.com"
    urlComponents.path = "/api/v1/locations"
    guard let url = urlComponents.url else { fatalError("Could not create URL from components")}

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                let decoder = JSONDecoder()
                do {
                    let locations = try decoder.decode([Location].self, from: jsonData)
                    completion?(.success(locations))
                } catch {
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from the request"]) as Error
                completion?(.failure(error))
            }
        }
    }
    task.resume()
}

func getLocation(id: Int, completion: ((Result<Location>) -> Void)?) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "pwrarnavapi.herokuapp.com"
    urlComponents.path = "/api/v1/locations/\(id)"
    guard let url = urlComponents.url else { fatalError("Could not create URL from components")}

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                let decoder = JSONDecoder()
                do {
                    let locations = try decoder.decode(Location.self, from: jsonData)
                    completion?(.success(locations))
                } catch {
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from the request"]) as Error
                completion?(.failure(error))
            }
        }
    }
    task.resume()
}
