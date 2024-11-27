//
//  BaseCell.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

// MARK: - BaseCollectionViewCell

class BaseCollectionViewCell: UICollectionViewCell {

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout

  final func setupUI() {
    setupSubviews()
    setupConstraints()
  }

  func setupSubviews() { }

  func setupConstraints() { }
  
  func updateUI() { }
}

class BaseTableViewCell: UITableViewCell {

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  final func setupUI() {
    setupSubviews()
    setupConstraints()
  }

  func setupSubviews() { }

  func setupConstraints() { }
  
  func updateUI() { }
}
