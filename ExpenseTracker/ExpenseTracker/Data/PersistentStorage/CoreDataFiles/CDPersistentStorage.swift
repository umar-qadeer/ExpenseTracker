
import Foundation
import CoreData

final class CDPersistentStorage {
    
    // MARK: - Core Data stack
    static let modelName = "ExpenseTracker"
    
    var persistentContainer: NSPersistentContainer
    
    lazy var viewContext = persistentContainer.viewContext
    
    // MARK: - Initializers
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - Core Data Functions
        
    func fetchManagedObjects<T: NSManagedObject>(context: NSManagedObjectContext, managedObject: T.Type, predicate: NSPredicate? = nil, completion: ((Result<[T]?, Error>) -> Void)) {
        
        do {
            let request = managedObject.fetchRequest()
            request.predicate = predicate
            let result = try context.fetch(request) as? [T]
            completion(.success(result))
        } catch {
            print(error)
            completion(.failure(error))
        }
    }
    
    func saveContext(context: NSManagedObjectContext, completion: ((Error?) -> Void)? = nil) {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    completion?(error)
                    return
                }
            }
        }
        
        DispatchQueue.main.async {
            completion?(nil)
        }
    }
}
