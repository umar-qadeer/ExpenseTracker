
import Foundation

struct TransactionPersistentStorage: PersistentStorageProtocol {
    
    // MARK: - Properties
    
    let storage: CDPersistentStorage
    
    // MARK: - Initializer
    
    init(storage: CDPersistentStorage) {
        self.storage = storage
    }
    
    // MARK: - PersistentStorageProtocol
    
    func fetchTransactions(completion: @escaping (Result<[Transaction]?, Error>) -> Void) {
        storage.viewContext.perform {

            storage.fetchManagedObjects(context: storage.viewContext, managedObject: CDTransaction.self, predicate: nil, completion: { result in

                switch result {
                case .success(let cdTransactions):
                    let transactions = cdTransactions?.map({ $0.convertToTransaction() })
                    completion(.success(transactions))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    func addTransaction(transaction: Transaction, completion: @escaping (Error?) -> Void) {
        storage.persistentContainer.performBackgroundTask { managedObjectContext in
            let cdTransaction = CDTransaction(context: managedObjectContext)
            cdTransaction.date = transaction.date
            cdTransaction.amount = transaction.amount
            cdTransaction.detail = transaction.description
            cdTransaction.type = transaction.type.rawValue
            storage.saveContext(context: managedObjectContext, completion: completion)
        }
    }
    
    func deleteTransaction(transaction: Transaction, completion: @escaping (Error?) -> Void) {
        let predicate = NSPredicate(format: "date = %@", transaction.date as NSDate)
        
        storage.persistentContainer.performBackgroundTask { managedObjectContext in
            
            storage.fetchManagedObjects(context: managedObjectContext, managedObject: CDTransaction.self, predicate: predicate, completion: { result in
                
                switch result {
                case .success(let cdTransactions):
                    if let cdTransaction = cdTransactions?.first {
                        managedObjectContext.delete(cdTransaction)
                    }
                    storage.saveContext(context: managedObjectContext, completion: completion)
                case .failure(let error):
                    completion(error)
                }
            })
        }
    }
}
