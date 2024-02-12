//
//  Choice+CoreDataProperties.swift
//  WikiChoice
//
//  Created by user196194 on 10/21/23.
//
//

import Foundation
import CoreData


extension Choice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Choice> {
        return NSFetchRequest<Choice>(entityName: "Choice")
    }

    @NSManaged public var title: String?
    @NSManaged public var dscrptn: String?
    @NSManaged public var link: String?
    @NSManaged public var image: Data?

}

extension Choice : Identifiable {

}
