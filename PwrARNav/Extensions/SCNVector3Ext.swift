//
//  SCNVector3Ext.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 16/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation
import ARKit

extension SCNVector3 {
    static func position(fromTransform transform: matrix_float4x4) -> SCNVector3 {
        
        //    column 0  column 1  column 2  column 3
        //         1        0         0       X    
        //         0        1         0       Y    
        //         0        0         1       Z    
        //         0        0         0       1    
        
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
}
