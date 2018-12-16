
import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
    
    func prepareForReuse()
}

extension Reusable {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

//TODO: improve generics
extension UITableView {
    @available(iOS 5.0, *)
    func registerReusable<T: Reusable>(reusableClass: T.Type, nib: UINib? = nil, bundle: Bundle = Bundle.main) {
        register(nib ?? UINib(nibName: T.reuseIdentifier, bundle: bundle) , forCellReuseIdentifier: T.reuseIdentifier)
    }

    @available(iOS 6.0, *)
    func dequeueReusableCell<T: UITableViewCell>(withClass reusableClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: reusableClass.reuseIdentifier, for: indexPath) as! T
    }

    @available(iOS 6.0, *)
    func dequeueReusableCell<T: UITableViewCell>(withClass reusableClass: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: reusableClass.reuseIdentifier) as! T
    }

    @available(iOS 6.0, *)
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass reusableClass: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: reusableClass.reuseIdentifier ) as? T
    }

    @available(iOS 6.0, *)
    func registerReusableNibForHeaderFooterView<T: UITableViewHeaderFooterView>(reusableClass: T.Type, nib: UINib? = nil) {
        register(nib ?? UINib(nibName: T.reuseIdentifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: reusableClass.reuseIdentifier)
    }
}
