import UIKit

// MARK: - Root tab bar (satisfies TabBarViewController requirement)
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buildTabs()
        tabBar.tintColor = .studyGreen
    }

    private func buildTabs() {
        // Tab 1 – Home
        let homeVC  = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"))

        // Tab 2 – Log
        let logVC  = LogSessionViewController()
        let logNav = UINavigationController(rootViewController: logVC)
        logNav.tabBarItem = UITabBarItem(
            title: "Log",
            image: UIImage(systemName: "timer"),
            selectedImage: UIImage(systemName: "timer"))

        // Tab 3 – History
        let histVC  = HistoryViewController()
        let histNav = UINavigationController(rootViewController: histVC)
        histNav.tabBarItem = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "clock"),
            selectedImage: UIImage(systemName: "clock.fill"))

        // Tab 4 – Stats
        let statsVC  = StatsViewController()
        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(
            title: "Stats",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill"))

        viewControllers = [homeNav, logNav, histNav, statsNav]
    }
}
