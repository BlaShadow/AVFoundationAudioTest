//
//  TimeIntervalHelper.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/16/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

extension TimeInterval {
  func parseTime() -> String {
    let seconds = Int(self) / 1000
    let remainMilliSeconds = Int(self) % 1000

    return "\(seconds).\(String(remainMilliSeconds).padding(toLength: 3, withPad: "000", startingAt: 0))"
  }
  
  func parseTimeSeconds() -> String {
    let minutes = Int(self) / 60
    let seconds = Int(self) % 60

    return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
  }
}
