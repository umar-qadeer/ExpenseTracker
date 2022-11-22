
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private(set) var appCoodinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        let appDIContainer = AppDIContainer()
        
        appCoodinator = AppCoordinator(navigationController: navigationController, appDIContainer: appDIContainer)
        appCoodinator?.start(from: .transactions)
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

