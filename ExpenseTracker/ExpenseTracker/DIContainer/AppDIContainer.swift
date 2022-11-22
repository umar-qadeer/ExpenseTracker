
import Foundation
import CoreData

final class AppDIContainer {
    
    lazy var persistentStore: PersistentStorageProtocol = {
        let persistentContainer = NSPersistentContainer(name: CDPersistentStorage.modelName)
        let cdStorage = CDPersistentStorage(persistentContainer: persistentContainer)
        return TransactionPersistentStorage(storage: cdStorage)
    }()
    
    func makeTransactionsDIContainer() -> TransactionsDIContainer {
        let dependencies = TransactionsDIContainer.Dependencies(persistentStorage: persistentStore)
        return TransactionsDIContainer(dependencies: dependencies)
    }
    
    func makeAddTransactionDIContainer() -> AddTransactionDIContainer {
        let dependencies = AddTransactionDIContainer.Dependencies(persistentStorage: persistentStore)
        return AddTransactionDIContainer(dependencies: dependencies)
    }
}
