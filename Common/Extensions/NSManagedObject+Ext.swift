//
//  NSManagedObject+Ext.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 01/02/2023.
//

import CoreData

public extension NSManagedObject {
  static var entityName: String { return NSStringFromClass(self) }
}
