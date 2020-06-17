//
//  RecordingsCollectionView.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RecordingsCollectionView: UIView {
  var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    view.showsVerticalScrollIndicator = false

    return view 
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.yellow
    
    self.setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.addSubview(self.collectionView)
    
    NSLayoutConstraint.activate([
      self.collectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.collectionView.heightAnchor.constraint(equalTo: self.heightAnchor),
      self.collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }
}
