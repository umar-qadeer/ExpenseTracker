
import Foundation
import CoreData


extension CDTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransaction> {
        return NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
    }

    @NSManaged public var date: Date
    @NSManaged public var amount: Double
    @NSManaged public var detail: String
    @NSManaged public var type: String
}

extension CDTransaction : Identifiable {

}
