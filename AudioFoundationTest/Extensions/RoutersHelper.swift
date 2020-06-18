//
//  RoutersHelper.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/18/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RoutersHelper {
  static func randomNameForRecording() -> String {
    return "recording_\(Date.timeIntervalSinceReferenceDate).pcm"
  }

  static func urlForRecordingAudio(_ name: String = "") -> URL? {
    guard let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }

    let nameRecording = name.isEmpty ? RoutersHelper.randomNameForRecording() : name
    let url = documentsPathURL.appendingPathComponent(nameRecording)

    return url
  }
}
