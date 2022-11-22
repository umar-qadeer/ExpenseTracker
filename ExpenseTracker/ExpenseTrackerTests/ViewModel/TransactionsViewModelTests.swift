
import XCTest
import CoreData
@testable import ExpenseTracker

final class TransactionsViewModelTests: XCTestCase {
    
    var persistentContainerMock: NSPersistentContainer!
    var cdPersistentStorageMock: CDPersistentStorage!
    var transactionPersistentStorageMock: TransactionPersistentStorage!
    var expectation: XCTestExpectation?
    var error: Error?
    
    override func setUp() {
        super.setUp()
        
        // set NSPersistentStoreDescription to make it temporary storage for testing
        persistentContainerMock = NSPersistentContainer(name: CDPersistentStorage.modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        persistentContainerMock.persistentStoreDescriptions = [persistentStoreDescription]
        
        cdPersistentStorageMock = CDPersistentStorage(persistentContainer: persistentContainerMock)
        transactionPersistentStorageMock = TransactionPersistentStorage(storage: cdPersistentStorageMock)
        
        error = nil
    }
    
    override func tearDown() {
        super.tearDown()
        
        expectation = nil
        error = nil
    }
    
    func addTransaction() {
        // given
        expectation = expectation(description: "Add transaction")
        
        let addTransactionRepository = AddTransactionRepository(persistentStorage: transactionPersistentStorageMock)
        
        let viewModel = AddTransactionViewModel(coordinator: self, repository: addTransactionRepository)
        
        // when
        viewModel.addTransaction(amount: "5000", type: TransactionType.income.rawValue, description: "Salary")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error, "Test Case Failed: got error on add transaction")
    }
    
    func testWhenFetchTransactions_thenViewModelTransactionsCountIsEqualToOne_succeeds() {
        self.addTransaction()
        
        // given
        expectation = expectation(description: "Fetch transactions")
        
        let transactionsRepository = TransactionsRepository(persistentStorage: transactionPersistentStorageMock)
        
        let viewModel = TransactionsViewModel(coordinator: self, repository: transactionsRepository)
        viewModel.delegate = self
        
        // when
        viewModel.fetchTransactions()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error, "Test Case Failed: got error on fetch transactions")
        XCTAssertEqual((viewModel.transactionSections?.count ?? 0), 1)
        XCTAssertEqual((viewModel.transactionSections?.first?.transactions.count ?? 0), 1)
        XCTAssertNotNil(viewModel.transactionSections?.first?.transactions.first?.date)
        XCTAssertNotNil(viewModel.transactionSections?.first?.transactions.first?.amount)
        XCTAssertNotNil(viewModel.transactionSections?.first?.transactions.first?.type)
        XCTAssertNotNil(viewModel.transactionSections?.first?.transactions.first?.description)
    }
    
    func testWhenAddTransaction_thenTransactionAddedWithNilError_succeeds() {
        self.addTransaction()
    }
    
    func testWhenDeleteTransaction_thenViewModelTransactionsCountIsEqualToZero_succeeds() {
        self.addTransaction()
        
        // given
        expectation = expectation(description: "Fetch transaction")
        
        let transactionsRepository = TransactionsRepository(persistentStorage: transactionPersistentStorageMock)
        
        let viewModel = TransactionsViewModel(coordinator: self, repository: transactionsRepository)
        viewModel.delegate = self
                
        viewModel.fetchTransactions()
        waitForExpectations(timeout: 5, handler: nil)
        
        expectation = expectation(description: "Delete transaction")
        
        let indexPath = IndexPath(row: 0, section: 1)
        
        // when
        viewModel.deleteTransaction(at: indexPath)
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error, "Test Case Failed: got error on delete transaction")
        XCTAssertEqual((viewModel.transactionSections?.count ?? 0), 0)
        XCTAssertEqual((viewModel.transactionSections?.first?.transactions.count ?? 0), 0)
    }
}

extension TransactionsViewModelTests: TransactionsViewModelCoordinationDelegate {
    func showErrorAlert(message: String?) {
        error = NSError.createError(message: message)
        expectation?.fulfill()
    }
    
    func showAddTransaction() {
        // no need to test, it's specific to UI
    }
}

extension TransactionsViewModelTests: TransactionsViewModelToViewDelegate {
    
    func updateUI() {
        expectation?.fulfill()
    }
    
    func showLoading(_ loading: Bool) {
        // no need to test, it's specific to UI
    }
}

extension TransactionsViewModelTests: AddTransactionViewModelCoordinationDelegate {
    
    func backToTransactions() {
        expectation?.fulfill()
    }
}
