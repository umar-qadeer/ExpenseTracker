
import UIKit

protocol CoordinatorProtocol {
    associatedtype Destination

    @discardableResult func start(from destination: Destination) -> UIViewController?
    @discardableResult func restart(from destination: Destination) -> UIViewController?
    func set(to destination: Destination)
    func push(to destination: Destination)
    func pop()
    func present(destination: Destination)
    func dismiss(animated: Bool)
    func makeViewController(for destination: Destination) -> UIViewController
}
