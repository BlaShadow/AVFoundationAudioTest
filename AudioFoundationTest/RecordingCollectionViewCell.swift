//
//  RecordingCollectionViewCell.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RecordingCollectionViewCell: UICollectionViewCell {
  var container: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.blue

    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setupView()
  }
  
  private func setupView() {
    self.addSubview(self.container)
    
    NSLayoutConstraint.activate([
      self.container.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20),
      self.container.heightAnchor.constraint(equalToConstant: 50),
      self.container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
