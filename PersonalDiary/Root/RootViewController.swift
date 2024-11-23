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
        let tabBarVC = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
        self.navigationController?.viewControllers = [tabBarVC]
    }
}

