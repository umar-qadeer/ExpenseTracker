
import Foundation

enum SectionType: Int {
    case summary
    case transaction
}

struct TransactionSection {
    var title: String
    var transactions: [Transaction]
}
