//
//  Recording.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit
import RealmSwift

class Recording: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var path: String = ""
  @objc dynamic var duration: Double = 0.0
  @objc dynamic var created: Date = Date()

  static func initRecording(name: String, path: String, duration: Double) -> Recording {
    let recording = Recording()

    recording.name = name
    recording.path = path
    recording.duration = duration

    return recording
  }
}
