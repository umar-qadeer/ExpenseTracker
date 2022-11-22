
import Foundation

enum TransactionType: String {
    case expense = "expense"
    case income = "income"
}

struct Transaction {
    var date: Date
    var amount: Double
    var description: String
    var type: TransactionType
    
    var groupByKey: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.monthNameDateYear
        return dateFormatter.string(from: self.date)
    }
}
