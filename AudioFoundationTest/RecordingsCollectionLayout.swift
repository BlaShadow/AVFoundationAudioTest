//
//  RecordingsCollectionLayout.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RecordingsCollectionLayout: NSObject, UICollectionViewDelegateFlowLayout {
  var selectionHandler: ((_ index: Int) -> Void)?

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let handler = self.selectionHandler {
      handler(indexPath.row)
    }
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width - 20, height: 75)
  }
}
