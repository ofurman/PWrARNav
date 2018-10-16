//
//  CLLocationExt.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 16/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    static func estimateBestLocation(locations: [CLLocation]) -> CLLocation {
        let sortedLocationEstimates = locations.sorted { (loc1, loc2) -> Bool in
            if loc1.horizontalAccuracy == loc2.horizontalAccuracy {
                return loc1.timestamp > loc2.timestamp
            }
            return loc1.horizontalAccuracy < loc2.horizontalAccuracy
        }
        return sortedLocationEstimates.first!
    }
}
