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
    do {
      let realm = try Realm()

      try realm.write {
        realm.add(recording)
      }
    } catch {
      print("Error saving recording \(error)")
    }
  }

  static func savedRecordings() -> [Recording] {
    do {
      let realm = try Realm()

      return realm.objects(Recording.self).map { $0 }
    } catch {
      print("Error fetching recordins \(error)")
    }

    return []
  }
}
