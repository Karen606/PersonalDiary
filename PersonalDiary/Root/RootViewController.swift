//
//  ViewController.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 22.11.24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(Date().getTodayAt(hour: 21), forKey: "notificationTime")
        }

        let tabBarVC = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
        self.navigationController?.viewControllers = [tabBarVC]
    }
}

