
import Foundation

protocol AddTransactionViewModelToViewDelegate {
    func showLoading(_ loading: Bool)
}

protocol AddTransactionViewModelCoordinationDelegate: BaseViewModelCoordinationDelegate {
    func backToTransactions()
}

final class AddTransactionViewModel {
    
    // MARK: - Properties
    
    private var coordinator: AddTransactionViewModelCoordinationDelegate
    private var repository: AddTransactionRepositoryProtocol
    var delegate: AddTransactionViewModelToViewDelegate?
    
    var transactionTypes: [String]

    // MARK: - Initializers
    
    init(coordinator: AddTransactionViewModelCoordinationDelegate, repository: AddTransactionRepositoryProtocol) {
        self.coordinator = coordinator
        self.repository = repository
        self.transactionTypes = [TransactionType.expense.rawValue, TransactionType.income.rawValue]
    }
    
    // MARK: - Functions
    
    func addTransaction(amount: String, type: String, description: String) {
        guard let amount = Double(amount),
              let type = TransactionType(rawValue: type) else {
            return
        }
        
        let transaction = Transaction(date: Date(), amount: amount, description: description, type: type)
        
        repository.addTransaction(transaction: transaction, completion: { [weak self] error in
            
            if let error = error {
                self?.coordinator.showErrorAlert(message: error.localizedDescription)
            } else {
                self?.backToTransactions()
            }
        })
    }
    
    func isValidInput(amount: String?, type: String?, description: String?) -> Bool {
        guard let amount = amount,
              let type = type,
              let description = description else {
            return false
        }
        
        return !(amount.isEmpty && type.isEmpty && description.isEmpty)
    }
    
    // MARK: - Navigation
    
    func backToTransactions() {
        coordinator.backToTransactions()
    }
}
