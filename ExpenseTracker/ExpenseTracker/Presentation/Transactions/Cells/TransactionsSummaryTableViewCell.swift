
import UIKit

final class TransactionsSummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    
    // MARK: - Configure
    
    func setupUI() {
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
    }
    
    func configure(transactionsSummary: TransactionsSummary) {
        let dollar = "$"
        let balance = transactionsSummary.income - transactionsSummary.expense
        
        expenseLabel.text = dollar + String(transactionsSummary.expense)
        incomeLabel.text = dollar + String(transactionsSummary.income)
        balanceLabel.text = dollar + String(balance)
        progressView.progress = Float(balance / transactionsSummary.income)
    }
}
