//
//  ManagedLocations+CoreDataProperties.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 21/11/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation
import CoreData

extension ManagedLocation {
    @NSManaged var id: Int
    @NSManaged var name: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
}
