//
//  RecordingsDataSource.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RecordingsDataSource: NSObject, UICollectionViewDataSource {
  var items: [Recording] = []

  override init() {
    super.init()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let rawCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath)

    guard let cell = rawCell as? RecordingCollectionViewCell else {
      return UICollectionViewCell(frame: .zero)
    }

    let recording = self.items[indexPath.row]

    cell.bindData(recording: recording)

    return cell
  }
}
