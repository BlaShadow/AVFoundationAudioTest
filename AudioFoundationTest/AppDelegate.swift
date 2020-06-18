//
//  AppDelegate.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var appCoordinator: AppCoordinator?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    if let window = window {
      window.makeKeyAndVisible()
      window.backgroundColor = UIColor.white

      self.appCoordinator = AppCoordinator()
      window.rootViewController = self.appCoordinator?.tabBarController()
    }

    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
      try session.setActive(true)

      session.requestRecordPermission { (granted) in
        print("Session grant access \(granted)")
      }
    } catch {
      print("Error configuring AVAudioSession \(error)")
    }

    return true
  }
}
