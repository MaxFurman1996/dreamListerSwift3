//
//  Item+CoreDataClass.swift
//  MyDreamLister
//
//  Created by Max Furman on 6/4/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
