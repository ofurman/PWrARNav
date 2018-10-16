//
//  DoubleExt.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 16/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

extension Double {
    func toRadians() -> Double {
        return self * (.pi / 180)
    }
    
    func toDegrees() -> Double {
        return self * 180 / .pi
    }
}
