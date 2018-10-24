////
////  APIRouterv1.swift
////  PwrARNav
////
////  Created by Oleksii Furman on 23/10/2018.
////  Copyright © 2018 Oleksii Furman. All rights reserved.
////
//
//import Foundation
//
//enum Result<Value> {
//    case success(Value)
//    case failure(Error)
//}
//
//class APIClient {
//    private func dataTask<T: Decodable>(request: NSMutableURLRequest, method: String,completion: @escaping (Result<T>) -> Void) {
//        request.httpMethod = method
//        
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        
//        session.dataTask(with: request as URLRequest) { (data, response, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else if let jsonData = data {
//                let decoder = JSONDecoder()
//                do {
//                    let data = try decoder.decode(T.self, from: jsonData)
//                    completion(.success(data))
//                } catch {
//                    completion(.failure(error))
//                }
//            } else {
//                let error = NSError(domain: "", code: 0,
//                                    userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from the request"]) as Error
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    private func post<T: Decodable>(request: NSMutableURLRequest, completion: @escaping (Result<T>) -> ()) {
//        dataTask(request: request, method: "POST", completion: completion)
//    }
//    
//    private func get<T: Decodable>(request: NSMutableURLRequest, completion: @escaping (Result<T>) -> Void) {
//        dataTask(request: request, method: "GET", completion: completion)
//    }
//    
//    private func clientURLRequest<T: Encodable>(path: String, params: T?) -> NSMutableURLRequest {
//        let request = NSMutableURLRequest(url: URL(string: "path to app" + path)!)
//        if let params = params {
//            let encoder = JSONEncoder()
//            let encodedParams = try! encoder.encode(params)
//            request.httpBody = encodedParams
//        }
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        return request
//    }
//    
//    func getLocations(completion: @escaping (Result<Location>) -> Void) {
//        get(request: clientURLRequest(path: "Asd", params: nil)) { (result: Result<Location>) -> Void in
//            <#code#>
//        }
//    }
//}
