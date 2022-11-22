
import Foundation

protocol AddTransactionRepositoryProtocol: AnyObject {
    func addTransaction(transaction: Transaction, completion: @escaping (Error?) -> Void)
}

final class AddTransactionRepository: AddTransactionRepositoryProtocol {
    
    // MARK: - Variables
    
    private let storage: PersistentStorageProtocol
    
    // MARK: - Init
    
    init(persistentStorage: PersistentStorageProtocol) {
        self.storage = persistentStorage
    }
    
    // MARK: - AddTransactionRepositoryProtocol
    
    func addTransaction(transaction: Transaction, completion: @escaping (Error?) -> Void) {
        storage.addTransaction(transaction: transaction, completion: completion)
    }
}
