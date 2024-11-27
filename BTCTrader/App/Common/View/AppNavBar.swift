//
//  AppNavBar.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

class AppNavBar: BaseView {
  
  // MARK: - Properties
  
  var onTapBack: (() -> Void)?
  
  // MARK: - UI Components

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .white
    return label
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Layout
  
  override func setupSubviews() {
    backgroundColor = .clear
    
    addSubview(backButton)
    addSubview(titleLabel)
  }
  
  override func setupConstraints() {
    backButton.snp.makeConstraints { make in
      make.width.height.equalTo(24)
      make.leading.equalToSuperview().offset(16)
      make.centerY.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.equalTo(22)
    }
  }
  
  // MARK: - Public Methods
  
  func setTitle(title: String) {
    titleLabel.text = "\(title) Chart"
  }
  
  // MARK: - Actions
  
  @objc private func backButtonTapped() {
    onTapBack?()
  }
}
