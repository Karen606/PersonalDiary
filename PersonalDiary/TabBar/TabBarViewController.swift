//
//  TabBarViewController.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 22.11.24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        let bgView = UIImageView(image: .tabBar)
        bgView.frame = self.tabBar.bounds
        self.tabBar.addSubview(bgView)
        self.tabBar.sendSubviewToBack(bgView)
        let calendarVC = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
        calendarVC.tabBarItem = UITabBarItem(title: "", image: .calendar, tag: 0)
        let settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        settingsVC.tabBarItem = UITabBarItem(title: "", image: .settings, tag: 1)
        viewControllers = [calendarVC, UIViewController(), settingsVC]
    }
}
