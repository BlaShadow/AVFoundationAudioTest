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
    view.backgroundColor = UIColor(rgb: 0xF8F8F8)

    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOffset = CGSize(width: 1, height: 1)
    view.layer.shadowOpacity = 0.7
    view.layer.shadowRadius = 1.5
    view.layer.cornerRadius = 3.0

    return view
  }()

  var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.text = "Name label"

    return label
  }()

  var createdDateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: FontNames.Montserrat.regular, size: 14)
    label.text = "Date Label"

    return label
  }()

  var durationLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .right
    label.text = "Duration"
    label.font = UIFont(name: FontNames.Montserrat.light, size: 12)

    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.setupView()
  }

  private func setupView() {
    self.addSubview(self.container)

    NSLayoutConstraint.activate([
      self.container.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20),
      self.container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
    ])

    self.container.addSubview(self.durationLabel)

    NSLayoutConstraint.activate([
      self.durationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
      self.durationLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
      self.durationLabel.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 10),
      self.durationLabel.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -10)
    ])

    self.container.addSubview(self.nameLabel)

    NSLayoutConstraint.activate([
      self.nameLabel.rightAnchor.constraint(equalTo: self.durationLabel.leftAnchor, constant: 5),
      self.nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
      self.nameLabel.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 10),
      self.nameLabel.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 10)
    ])

    self.container.addSubview(self.createdDateLabel)

    NSLayoutConstraint.activate([
      self.createdDateLabel.widthAnchor.constraint(equalTo: self.container.widthAnchor, multiplier: 0.8),
      self.createdDateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
      self.createdDateLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
      self.createdDateLabel.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor)
    ])
  }

  func bindData(recording: Recording) {
    self.nameLabel.text = recording.name

    self.durationLabel.text = recording.duration.parseTimeSeconds()
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MMM dd, yyyy h:mm a"
    self.createdDateLabel.text = dateFormatterPrint.string(from: recording.created)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
