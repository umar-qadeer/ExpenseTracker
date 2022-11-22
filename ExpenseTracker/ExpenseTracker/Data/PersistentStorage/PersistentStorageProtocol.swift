
import Foundation

protocol PersistentStorageProtocol {
    func fetchTransactions(completion: @escaping (Result<[Transaction]?, Error>) -> Void)
    func addTransaction(transaction: Transaction, completion: @escaping (Error?) -> Void)
    func deleteTransaction(transaction: Transaction, completion: @escaping (Error?) -> Void)
}
