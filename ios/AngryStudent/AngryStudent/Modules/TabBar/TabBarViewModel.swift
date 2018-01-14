import Foundation
import UIKit


class TabBarViewModel {
    
    // MARK: - Properties
    
    private let eventSizePercentage: CGFloat = 0.15
    private let mapSizePercentage: CGFloat = 0.13
    private let friendstSizePercentage: CGFloat = 0.14
    
    // MARK: - Initialization
    
    init() {
    }
    
    // MARK: - Actions
    
    public func getTabBarItems() -> [UITabBarItem] {
        let tabBarEvents = UITabBarItem(title: R.string.events_list_tab_bar^, image: #imageLiteral(resourceName: "CalendarPlus").resizeWith(percentage: eventSizePercentage)?.withRenderingMode(. alwaysOriginal), selectedImage: #imageLiteral(resourceName: "CalendarPlus").resizeWith(percentage: eventSizePercentage))
        
        let tabBarMap = UITabBarItem(title: R.string.main_map_tab_bar^, image: #imageLiteral(resourceName: "Map").resizeWith(percentage: mapSizePercentage)?.withRenderingMode(. alwaysOriginal), selectedImage: #imageLiteral(resourceName: "Map").resizeWith(percentage: mapSizePercentage))
        
        let tabBarFrends = UITabBarItem(title: R.string.friends_tab_bar^, image: #imageLiteral(resourceName: "Users").resizeWith(percentage: friendstSizePercentage)?.withRenderingMode(. alwaysOriginal), selectedImage: #imageLiteral(resourceName: "Users").resizeWith(percentage: friendstSizePercentage)
        )
        
        return [tabBarEvents, tabBarMap, tabBarFrends]
    }
}

