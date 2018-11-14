//
//  LocationViewModel.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 27/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct LocationViewModel {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(location: Location) {
        self.id = location.id
        self.name = location.name ?? ""
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
}
