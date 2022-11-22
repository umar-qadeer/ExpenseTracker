
import Foundation

protocol TransactionsViewModelToViewDelegate {
    func updateUI()
    func showLoading(_ loading: Bool)
}

protocol TransactionsViewModelCoordinationDelegate: BaseViewModelCoordinationDelegate {
    func showAddTransaction()
}

final class TransactionsViewModel {
    
    // MARK: - Properties
    
    private var coordinator: TransactionsViewModelCoordinationDelegate
    private var repository: TransactionsRepositoryProtocol
    var delegate: TransactionsViewModelToViewDelegate?
    
    var transactionsSummary: TransactionsSummary?
    var transactionSections: [TransactionSection]?

    // MARK: - Initializers
    
    init(coordinator: TransactionsViewModelCoordinationDelegate, repository: TransactionsRepositoryProtocol) {
        self.coordinator = coordinator
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func fetchTransactions() {
        delegate?.showLoading(true)
        
        repository.fetchTransactions(completion: { [weak self] result in
            self?.delegate?.showLoading(false)
            
            switch result {
            case .success(let transactions):
                self?.setupTableViewSectionsData(transactions: transactions)
                self?.delegate?.updateUI()
            case .failure(let error):
                self?.coordinator.showErrorAlert(message: error.localizedDescription)
            }
        })
    }
    
    func deleteTransaction(at indexPath: IndexPath) {
        guard let transaction = transaction(at: indexPath) else {
            return
        }
        
        delegate?.showLoading(true)
        
        repository.deleteTransaction(transaction: transaction) { [weak self] error in
            self?.delegate?.showLoading(false)
            
            if let error = error {
                self?.coordinator.showErrorAlert(message: error.localizedDescription)
            } else {
                // There is room for improvement of this logic, so that we don't fetch complete data on every delete
                self?.fetchTransactions()
            }
        }
    }
    
    private func setupTableViewSectionsData(transactions: [Transaction]?) {
        guard let transactions = transactions else {
            return
        }

        self.transactionSections = setupTransactionSections(transactions: transactions)
        self.transactionsSummary = setupTransactionsSummarySection(transactions: transactions)
    }
    
    private func setupTransactionsSummarySection(transactions: [Transaction]) -> TransactionsSummary {
        var expense: Double = 0
        var income: Double = 0
        
        transactions.forEach { transaction in
            
            if transaction.type == .income {
                income += transaction.amount
            } else {
                expense += transaction.amount
            }
        }
        
        return TransactionsSummary(expense: expense, income: income)
    }
    
    private func setupTransactionSections(transactions: [Transaction]) -> [TransactionSection] {
        // Group transactions by day
        let groupedDict = Dictionary(grouping: transactions, by: { $0.groupByKey })
        
        // convert dict to array
        var transactionSections = groupedDict.map { (key, value) in
            return TransactionSection(title: key, transactions: value)
        }
        
        // sort sections by their first transaction date
        transactionSections.sort(by: { section1, section2 in
            guard let transaction1 = section1.transactions.first,
                  let transaction2 = section2.transactions.first else {
                return false
            }
            
            return transaction1.date > transaction2.date
        })
        
        return transactionSections
    }
    
    func numberOfSections() -> Int {
        // adding 1 for transaction summary cell
        return 1 + (transactionSections?.count ?? 0)
    }
    
    func numberOfRows(in section: Int) -> Int {
        return section == SectionType.summary.rawValue ? 1 : (transactionSections?[trueTransactionSection(for: section)].transactions.count ?? 0)
    }
    
    func typeOfSection(_ section: Int) -> SectionType {
        return section == SectionType.summary.rawValue ? .summary : .transaction
    }
    
    func title(for section: Int) -> String? {
        return transactionSections?[trueTransactionSection(for: section)].title
    }
    
    func transaction(at indexPath: IndexPath) -> Transaction? {
        return transactionSections?[trueTransactionSection(for: indexPath.section)].transactions[indexPath.row]
    }
    
    private func trueTransactionSection(for section: Int) -> Int {
        return section - 1
    }
    
    // MARK: - Navigation
    
    func didTapAddTransaction() {
        coordinator.showAddTransaction()
    }
}
