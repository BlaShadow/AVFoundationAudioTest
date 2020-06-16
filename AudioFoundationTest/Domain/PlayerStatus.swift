//
//  PlayerStatus.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/10/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

enum RecordingPlayerStatus: String {
  case iddle
  case startRecording
  case stopRecording
  case startPlaying
  case stopPlaying
}

enum AudioPlayerStatus: String {
  case iddle
  case playing
  case pause
}
