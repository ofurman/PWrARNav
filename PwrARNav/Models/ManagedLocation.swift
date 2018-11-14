//
//  ManagedLocation.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 22/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//
import CoreData

@objc(Location)
class ManagedLocation: NSManagedObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
    }
    
    @NSManaged var id: Int
    @NSManaged var name: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedObjectContext) else {
                fatalError("Failed to decode Location")
        }
        
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)!
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)!
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)!
        
        
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
