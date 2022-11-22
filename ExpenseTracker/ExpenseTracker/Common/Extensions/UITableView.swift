
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String {get}
}

extension ReusableView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}

extension UITableView {
    
    func registerCell<T: UITableViewCell>(class: T.Type) {
        self.register(UINib(nibName: T.className(), bundle: nil),
                           forCellReuseIdentifier: T.className())
    }
    
    func dequeReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque reusable cell with identifier " + T.reuseIdentifier)
        }
        return cell
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(class: T.Type) {
        let headerNib = UINib(nibName: T.className(), bundle: Bundle.main)
        self.register(headerNib, forHeaderFooterViewReuseIdentifier: T.className())
    }
    
    func dequeReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Unable to deque reusable headerFooter with identifier  " + T.reuseIdentifier)
        }
        return headerFooterView
    }
}
