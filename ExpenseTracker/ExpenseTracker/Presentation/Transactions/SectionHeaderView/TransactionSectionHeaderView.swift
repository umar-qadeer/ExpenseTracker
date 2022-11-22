
import UIKit

final class TransactionSectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!

    func configure(title: String?) {
        titleLabel.text = title
    }
}
