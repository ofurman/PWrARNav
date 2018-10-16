//
//  CLLocationCoordinate2DExt.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 16/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func calculateBearing(to coordinate: CLLocationCoordinate2D) -> Double {
        
        /*
         ‘R’ is the radius of Earth
         ‘L’ is the longitude
         ‘θ’ is latitude
         ‘β‘ is bearing
         ‘∆‘ is delta / change in
         
         β = atan2(X,Y)
         where, X and Y are two quantities and can be calculated as:
         X = cos θb * sin ∆L
         Y = cos θa * sin θb — sin θa * cos θb * cos ∆L
         */
        let a = sin(coordinate.longitude.toRadians() - longitude.toRadians()) * cos(coordinate.latitude.toRadians())
        let b = cos(latitude.toRadians()) * sin(coordinate.latitude.toRadians()) - sin(latitude.toRadians()) * cos(coordinate.latitude.toRadians()) * cos(coordinate.longitude.toRadians() - longitude.toRadians())
        return atan2(a, b)
    }
    func direction(to coordinate: CLLocationCoordinate2D) -> CLLocationDirection {
        return self.calculateBearing(to: coordinate).toDegrees()
    }
}

let metersPerRadianLat: Double = 6373000.0
let metersPerRadianLon: Double = 5602900.0

extension CLLocationCoordinate2D {
    func coordinate(with bearing: Double, and distance: Double) -> CLLocationCoordinate2D {
        let distanceRadLat = distance / metersPerRadianLat
        let distanceRadLon = distance / metersPerRadianLon
        let lat1 = self.latitude.toRadians()
        let lon1 = self.longitude.toRadians()
        
        /*
         ‘d‘ being the distance travelled
         ‘R’ is the radius of Earth
         ‘L’ is the longitude
         ‘φ’ is latitude
         ‘θ‘ is bearing (clockwise from north)
         ‘δ‘ is the angular distance d/R
         
         φ2 = asin( sin φ1 ⋅ cos δ + cos φ1 ⋅ sin δ ⋅ cos θ )
         L2 = L1 + atan2( sin θ ⋅ sin δ ⋅ cos φ1, cos δ − sin φ1 ⋅ sin φ2 )
         */
        
        let lat2 = asin(sin(lat1) * cos(distanceRadLat) + cos(lat1) * sin(distanceRadLat) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distanceRadLon) * cos(lat1), cos(distanceRadLon) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2.toDegrees(), longitude: lon2.toDegrees())
    }
    
    
}

