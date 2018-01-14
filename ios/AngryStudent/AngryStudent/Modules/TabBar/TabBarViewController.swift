import Foundation
import UIKit


class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    let viewModel = TabBarViewModel()
    var tabBarViewControllers: [UIViewController] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Helpers
    
    private func setupTabBar() {
        tabBar.barTintColor = Color.white
        tabBar.shadowImage = nil
        tabBar.backgroundColor = Color.white
        tabBar.tintColor = Color.blueDark
        setupTabBarControllers()
    }
    
    
    private func setupTabBarControllers() {
        let tabBarItems = viewModel.getTabBarItems()
        initializeViewControllers()
        for (index, tabBarViewController) in tabBarViewControllers.enumerated() {
            tabBarViewController.tabBarItem = tabBarItems[index]
        }
        self.viewControllers = tabBarViewControllers
    }
    
    
    private func initializeViewControllers() {
        let eventVC = UIStoryboard(name: "Events", bundle: nil).instantiateInitialViewController()
        let mapVC = UIStoryboard(name: "MainMap", bundle: nil).instantiateInitialViewController()
        let friendsVc = UIStoryboard(name: "Friends", bundle: nil).instantiateInitialViewController()
        tabBarViewControllers = [eventVC!, mapVC!, friendsVc!]
    }
}
