import Foundation
import CoreData

@objc(MOHero)
public class MOHero: NSManagedObject {

}

extension MOHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOHero> {
        return NSFetchRequest<MOHero>(entityName: "CDHero")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var photo: String?
    @NSManaged public var locations: Set<MOLocation>?
    @NSManaged public var transformations: Set<MOTransformation>?
}

extension MOHero {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: MOLocation)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: MOLocation)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: Set<MOLocation>)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: Set<MOLocation>)

}

// MARK: Generated accessors for transformations
extension MOHero {

    @objc(addTransformationsObject:)
    @NSManaged public func addToTransformations(_ value: MOTransformation)

    @objc(removeTransformationsObject:)
    @NSManaged public func removeFromTransformations(_ value: MOTransformation)

    @objc(addTransformations:)
    @NSManaged public func addToTransformations(_ values: Set<MOTransformation>)

    @objc(removeTransformations:)
    @NSManaged public func removeFromTransformations(_ values: Set<MOTransformation>)

}

extension MOHero : Identifiable {

}
