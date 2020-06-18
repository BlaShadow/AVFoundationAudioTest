//
//  RecordingsViewController.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/14/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RecordingsViewController: UIViewController {
  var recordingsView: RecordingsCollectionView?
  let recordingsDataSource = RecordingsDataSource()
  let layoutDelegate = RecordingsCollectionLayout()
  var recordings: [Recording] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    self.recordingsView = RecordingsCollectionView()

    if let view = self.recordingsView {
      self.view.addSubview(view)

      NSLayoutConstraint.activate([
        view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        view.heightAnchor.constraint(equalTo: self.view.heightAnchor),
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ])

      self.layoutDelegate.selectionHandler = self.recordingClickHandler

      view.collectionView.register(RecordingCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
      view.collectionView.dataSource = self.recordingsDataSource
      view.collectionView.delegate = self.layoutDelegate
      view.collectionView.reloadData()
    }
  }

  private func recordingClickHandler(_ index: Int) {
    let path = self.recordings[index].path

    // Setup player
    let urlString = RoutersHelper.urlForRecordingAudio(path)?.absoluteString
    self.recordingsView?.playerView.setupPlayer(url: urlString ?? "")
    self.recordingsView?.displayAudioPlayer()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.recordings = DataBaseAcess.savedRecordings().sorted(by: { (itemA, itemB) -> Bool in
      return itemA.created > itemB.created
    })

    self.reloadData()
  }

  private func reloadData() {
    self.recordingsDataSource.items = self.recordings
    self.recordingsView?.collectionView.reloadData()
  }
}
