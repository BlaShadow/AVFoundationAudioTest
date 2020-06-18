//
//  RecordingPlayerViewController.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/17/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RecordingPlayerViewController: UIViewController {
  var recording: Recording?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor.red

    print("Display recording \(self.recording?.path ?? "(None)")")
  }
}
