//
//  AppCoordinator.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/14/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class AppCoordinator {
  let recordViewController: RecordViewController
  let recordingsViewController: RecordingsViewController

  let tabViewController: UITabBarController

  init() {
    self.tabViewController = UITabBarController()

    self.recordingsViewController = RecordingsViewController()
    self.recordViewController = RecordViewController()

    self.setupTabBar()
  }

  private func setupTabBar() {
    self.recordViewController.tabBarItem = UITabBarItem(title: "Record", image: UIImage(named: "tabBarRecord"), tag: 0)
    self.recordingsViewController.tabBarItem = UITabBarItem(title: "Recordings", image: UIImage(named: "tabBarRecordings"), tag: 1)

    self.tabViewController.viewControllers = [self.recordViewController, self.recordingsViewController]
  }
  
  func tabBarController() -> UIViewController {
    return self.tabViewController
  }
}
