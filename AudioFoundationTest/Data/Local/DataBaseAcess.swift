//
//  DataBaseAcess.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/16/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import RealmSwift

class DataBaseAcess {
  static func saveRecording(recording: Recording) {
    let realm = try! Realm()

    try! realm.write {
      realm.add(recording)
      print("Recording saved! \(recording.duration)")
    }
  }
  
  static func savedRecordings() -> [Recording] {
    let realm = try! Realm()
    
    return realm.objects(Recording.self).map { $0 }
  }
}
