//
//  BindableLayout.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import Foundation

// MARK: - Layoutable

protocol Layoutable {
  func setupUI()
  func setupSubviews()
  func setupConstraints()
  func updateUI()
}

// MARK: - Bindable

protocol Bindable {
  func bind()
}

typealias BindableLayout = Bindable & Layoutable
