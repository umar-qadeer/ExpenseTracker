
import Foundation

final class AddTransactionDIContainer {
    
    struct Dependencies {
        let persistentStorage: PersistentStorageProtocol
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    private func makeAddTransactionRepository() -> AddTransactionRepository {
        return AddTransactionRepository(persistentStorage: dependencies.persistentStorage)
    }
    
    // MARK: - ViewModel
    
    private func makeAddTransactionViewModel(coordinator: AddTransactionViewModelCoordinationDelegate) -> AddTransactionViewModel {
        return AddTransactionViewModel(coordinator: coordinator, repository: makeAddTransactionRepository())
    }
    
    // MARK: - ViewController
    
    func makeAddTransactionViewController(_ coordinator: AppCoordinator) -> AddTransactionViewController {
        let viewModel = makeAddTransactionViewModel(coordinator: coordinator)
        let viewController = AddTransactionViewController(viewModel: viewModel)
        return viewController
    }
}
