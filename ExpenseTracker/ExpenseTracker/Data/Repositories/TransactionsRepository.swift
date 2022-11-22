
import Foundation

protocol TransactionsRepositoryProtocol: AnyObject {
    func fetchTransactions(completion: @escaping (Result<[Transaction]?, Error>) -> Void)
    func deleteTransaction(transaction: Transaction, completion: @escaping (Error?) -> Void)
}

final class TransactionsRepository: TransactionsRepositoryProtocol {
    
    // MARK: - Variables
    
    private let storage: PersistentStorageProtocol
    
    // MARK: - Init
    
    init(persistentStorage: PersistentStorageProtocol) {
        self.storage = persistentStorage
    }
    
    // MARK: - TransactionsRepositoryProtocol
    
    func fetchTransactions(completion: @escaping (Result<[Transaction]?, Error>) -> Void) {
        storage.fetchTransactions(completion: completion)
    }
    
    func deleteTransaction(transaction: Transaction, completion: @escaping (Error?) -> Void) {
        storage.deleteTransaction(transaction: transaction, completion: completion)
    }
}
