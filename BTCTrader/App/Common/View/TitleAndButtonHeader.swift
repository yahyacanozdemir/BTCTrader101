//
//  TitleAndButtonHeader.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 30.11.2024.
//

import UIKit

class TitleAndButtonHeader: BaseView {
  
  // MARK: - Properties
  var title: String
  var buttonTitle: String
  var buttonTapHandler: (() -> Void)?
  
  // MARK: - Initialization
  init(title: String, buttonTitle: String) {
    self.title = title
    self.buttonTitle = buttonTitle
    super.init()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Components
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .boldSystemFont(ofSize: 28)
    titleLabel.textColor = .btcTurkWhite
    return titleLabel
  }()
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.setTitle(buttonTitle, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 10)
    button.titleLabel?.textColor = .btcTurkRed
    button.addTarget(self, action: #selector(clearFavorites),for: .touchUpInside)
    return button
  }()
  
  // MARK: - Layout
  override func setupSubviews() {
    backgroundColor = .btcTurkDark
    
    addSubview(titleLabel)
    addSubview(button)
  }
  
  override func setupConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.top.bottom.leading.equalToSuperview()
    }
    
    button.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-16)
    }
  }
  
  @objc func clearFavorites() {
    buttonTapHandler?()
  }
}
