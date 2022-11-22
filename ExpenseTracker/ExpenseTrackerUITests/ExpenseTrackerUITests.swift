
import XCTest
import CoreData
@testable import ExpenseTracker

final class ExpenseTrackerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()

        app = nil
    }

    func testWhenTransactionsAreLoaded_thenTransactionSummaryCellExists_succeeds() {
        let app = XCUIApplication()
        let tableViewsQuery = app.tables
        let transactionSummaryCell = tableViewsQuery.cells[AccessibilityIdentifier.transactionSummaryCell].firstMatch
        _ = transactionSummaryCell.waitForExistence(timeout: 2.0)

        XCTAssertNotNil(transactionSummaryCell.exists)
    }
    
    func testWhenAddTransactionTapped_thenAppNavigatesToAddTransactionScreen_succeeds() {
        app.navigationBars.buttons[AccessibilityIdentifier.addBarButtonItem].tap()
        let addTransactionButton = app.buttons[AccessibilityIdentifier.addTransactionButton]
        _ = addTransactionButton.waitForExistence(timeout: 2.0)
        XCTAssert(addTransactionButton.exists)
    }

    func testWhenAddTransaction_thenTransactionCellExists_succeeds() {
        app.navigationBars.buttons[AccessibilityIdentifier.addBarButtonItem].tap()

        // enter amount
        let amountTextField = app.textFields[AccessibilityIdentifier.amountTextField]
        amountTextField.tap()
        amountTextField.typeText("5000")

        let typeTextField = app.textFields[AccessibilityIdentifier.typeTextField]
        typeTextField.tap()

        // select income from picker
        let picker = app.pickers
        picker.pickerWheels.element.adjust(toPickerWheelValue: "income")
        app.toolbars.buttons[AccessibilityIdentifier.doneBarButtonItem].tap()

        // enter descriprtion
        let descriptionTextField = app.textFields[AccessibilityIdentifier.descriptionTextField]
        descriptionTextField.tap()
        descriptionTextField.typeText("Salary")

        app.buttons[AccessibilityIdentifier.addTransactionButton].tap()

        let tableView = app.tables

        let transactionCell = tableView.cells[AccessibilityIdentifier.transactionCell]
        _ = transactionCell.waitForExistence(timeout: 2.0)
        XCTAssert(transactionCell.staticTexts["$5000.0"].exists)
    }
}
