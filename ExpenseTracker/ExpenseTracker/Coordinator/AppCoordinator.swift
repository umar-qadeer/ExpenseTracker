
import UIKit

final class AppCoordinator: CoordinatorProtocol {
    
    enum Destination {
        case transactions
        case addTransaction
        case errorAlert(message: String?)
    }
    
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController?
    private var appDIContainer: AppDIContainer
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Coordinator
    
    @discardableResult func start(from destination: Destination = .transactions) -> UIViewController? {
        set(to: destination)
        return self.navigationController
    }
    
    @discardableResult func restart(from destination: Destination = .transactions) -> UIViewController? {
        set(to: destination)
        return self.navigationController
    }
    
    func set(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.setViewControllers([viewController], animated: false)
    }
    
    func push(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func present(destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.present(viewController, animated: true)
    }
    
    func dismiss(animated: Bool = true) {
        self.navigationController?.dismiss(animated: animated)
    }
    
    func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .transactions:
            let diContainer = appDIContainer.makeTransactionsDIContainer()
            let viewController = diContainer.makeTransactionsViewController(self)
            return viewController
            
        case .addTransaction:
            let diContainer = appDIContainer.makeAddTransactionDIContainer()
            let viewController = diContainer.makeAddTransactionViewController(self)
            return viewController
            
        case .errorAlert(let message):
            let alertController = UIAlertController(title: Strings.Alert.error, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: Strings.Alert.cancel, style: .cancel, handler: nil)
            alertController.addAction(action)
            return alertController
        }
    }
}

extension AppCoordinator: BaseViewModelCoordinationDelegate {
    
    func showErrorAlert(message: String?) {
        present(destination: .errorAlert(message: message))
    }
}

extension AppCoordinator: TransactionsViewModelCoordinationDelegate {
    
    func showAddTransaction() {
        push(to: .addTransaction)
    }
}

extension AppCoordinator: AddTransactionViewModelCoordinationDelegate {
    
    func backToTransactions() {
        pop()
    }
}
