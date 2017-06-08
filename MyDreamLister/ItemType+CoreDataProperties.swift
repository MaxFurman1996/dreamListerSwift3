//
//  ItemType+CoreDataProperties.swift
//  MyDreamLister
//
//  Created by Max Furman on 6/4/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
