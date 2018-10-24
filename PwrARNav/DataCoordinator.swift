//
//  DataCoordinator.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 24/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

final class DataCoordinator {
    private static var coordinator: DataCoordinator?
    public class func sharedInstance() -> DataCoordinator {
        if coordinator == nil {
            coordinator = DataCoordinator()
        }
        return coordinator!
    }
    
    private init() {
        
    }
}
