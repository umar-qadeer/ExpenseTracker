
import Foundation

final class TransactionsDIContainer {
    
    struct Dependencies {
        let persistentStorage: PersistentStorageProtocol
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    private func makeTransactionsRepository() -> TransactionsRepository {
        return TransactionsRepository(persistentStorage: dependencies.persistentStorage)
    }
    
    // MARK: - ViewModel
    
    private func makeTransactionsViewModel(coordinator: TransactionsViewModelCoordinationDelegate) -> TransactionsViewModel {
        return TransactionsViewModel(coordinator: coordinator, repository: makeTransactionsRepository())
    }
    
    // MARK: - ViewController
    
    func makeTransactionsViewController(_ coordinator: AppCoordinator) -> TransactionsViewController {
        let viewModel = makeTransactionsViewModel(coordinator: coordinator)
        let viewController = TransactionsViewController(viewModel: viewModel)
        return viewController
    }
}
