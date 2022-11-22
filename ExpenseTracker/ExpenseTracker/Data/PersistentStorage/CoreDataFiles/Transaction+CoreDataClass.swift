
import Foundation
import CoreData

@objc(CDTransaction)
public class CDTransaction: NSManagedObject {

    func convertToTransaction() -> Transaction {
        
        guard let transactionType = TransactionType(rawValue: self.type) else {
            fatalError("handle new transaction type")
        }
        
        return Transaction(date: self.date, amount: self.amount, description: self.detail, type: transactionType)
    }
}
