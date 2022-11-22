
import UIKit

final class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    
    // MARK: - Configure
    
    func setupUI() {
        containerView.layer.cornerRadius = 18
        containerView.clipsToBounds = true
        
        logoImageView.layer.borderWidth = 2
        logoImageView.layer.cornerRadius = 10
    }
    
    func configure(transaction: Transaction) {
        let dollar: String
        let borderColor: UIColor
        
        if transaction.type == .expense {
            dollar = "- $"
            borderColor = .systemRed
        } else {
            dollar = "$"
            borderColor = .systemGreen
        }
        
        titleLabel.text = transaction.description
        amountLabel.text = dollar + String(transaction.amount)
        logoImageView.layer.borderColor = borderColor.cgColor
        logoImageView.image = UIImage(named: transaction.type.rawValue)
    }
}
