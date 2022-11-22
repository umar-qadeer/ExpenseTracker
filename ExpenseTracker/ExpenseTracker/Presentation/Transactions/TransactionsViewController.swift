
import UIKit

final class TransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TransactionsViewModelToViewDelegate {
    
    // MARK: - Properties
    
    private var viewModel: TransactionsViewModel
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Strings.List.pullToRefresh)
        return refreshControl
    }()
    
    // MARK: IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Initializers
    
    init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchTransactions()
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        // refresh control
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
        
        tableView.registerHeaderFooter(class: TransactionSectionHeaderView.self)
        tableView.registerCell(class: TransactionsSummaryTableViewCell.self)
        tableView.registerCell(class: TransactionTableViewCell.self)
    }
    
    private func setupNavigationBar() {
        self.title = Strings.Titles.transactions
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddTransactionButton))
        addBarButtonItem.accessibilityIdentifier = AccessibilityIdentifier.addBarButtonItem
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    // MARK: - Selectors
    
    @objc private func didPullToRefresh() {
        viewModel.fetchTransactions()
    }
    
    @objc private func didTapAddTransactionButton() {
        viewModel.didTapAddTransaction()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.typeOfSection(indexPath.section) == .summary {
            guard let transactionsSummary = viewModel.transactionsSummary else {
                return UITableViewCell()
            }
            
            let cell: TransactionsSummaryTableViewCell = tableView.dequeReusableCell(for: indexPath)
            cell.configure(transactionsSummary: transactionsSummary)
            return cell
        } else {
            guard let transaction = viewModel.transaction(at: indexPath) else {
                return UITableViewCell()
            }
            
            let cell: TransactionTableViewCell = tableView.dequeReusableCell(for: indexPath)
            cell.configure(transaction: transaction)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.typeOfSection(indexPath.section) != .summary
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.deleteTransaction(at: indexPath)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.typeOfSection(section) == .summary {
            return nil
        } else {
            let transactionSectionHeaderView: TransactionSectionHeaderView = tableView.dequeReusableHeaderFooter()
            transactionSectionHeaderView.configure(title: viewModel.title(for: section))
            return transactionSectionHeaderView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.typeOfSection(section) == .summary ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: - TransactionsViewModelToViewDelegate
    
    func updateUI() {
        tableView.reloadData()
    }
    
    func showLoading(_ loading: Bool) {
        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        if !loading {
            self.refreshControl.endRefreshing()
        }
    }
}
