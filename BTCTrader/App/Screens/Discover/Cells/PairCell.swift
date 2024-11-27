//
//  PairCell.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

class PairCell: BaseTableViewCell {
  
  // MARK: - Properties
  var cellData: Pair? {
    didSet { updateUI() }
  }
  
  var favoriteButtonAction: (() -> Void)?
  
  // UI Elements
  private lazy var favoriteButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "star"), for: .normal)
    button.setImage(UIImage(systemName: "star.fill"), for: .selected)
    button.tintColor = .orange
    button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var nameLabel = createLabel(font: .systemFont(ofSize: 18), textColor: .btcTurkWhite)
  private lazy var lastPriceLabel = createLabel(font: .boldSystemFont(ofSize: 16), textColor: .btcTurkWhite)
  private lazy var dailyPercentLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .btcTurkGreen)
  private lazy var volumeLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .btcTurkGray)
  private lazy var numeratorSymbolLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .btcTurkGray)
  private lazy var pairNormalizedLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .btcTurkGreen)
  
  lazy var bottomLine: UIView = {
    let view = UIView()
    view.backgroundColor = .separator
    return view
  }()
  
  // MARK: - Layout
  override func setupSubviews() {
    selectionStyle = .none
    backgroundColor = .clear
    
    let subviews = [
      favoriteButton,
      nameLabel,
      lastPriceLabel,
      dailyPercentLabel,
      volumeLabel,
      numeratorSymbolLabel,
      bottomLine
    ]
    
    subviews.forEach { contentView.addSubview($0) }
  }
  
  override func setupConstraints() {
    favoriteButton.snp.makeConstraints { make in
      make.centerY.equalTo(nameLabel)
      make.leading.equalToSuperview().offset(16)
      make.size.equalTo(32)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.leading.equalTo(favoriteButton.snp.trailing).offset(12)
      make.bottom.equalTo(bottomLine.snp.top).offset(-16)
    }
    
    lastPriceLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.trailing.equalTo(dailyPercentLabel.snp.leading).offset(-4)
      make.bottom.equalTo(volumeLabel.snp.top).offset(-6)
    }
    
    dailyPercentLabel.snp.makeConstraints { make in
      make.top.equalTo(lastPriceLabel.snp.top).offset(4)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalTo(volumeLabel.snp.top).offset(-6)
    }
    
    volumeLabel.snp.makeConstraints { make in
      make.trailing.equalTo(numeratorSymbolLabel.snp.leading).offset(-4)
    }
    
    numeratorSymbolLabel.snp.makeConstraints { make in
      make.top.equalTo(volumeLabel.snp.top)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    bottomLine.snp.makeConstraints { make in
      make.top.equalTo(volumeLabel.snp.bottom).offset(10)
      make.height.equalTo(2)
      make.width.equalToSuperview()
    }
  }
  
  override func updateUI() {
    guard let pair = cellData else { return }
    
    favoriteButton.isSelected = pair.isFavorite ?? false
    nameLabel.text = pair.pair
    lastPriceLabel.text = pair.last?.formattedString
    dailyPercentLabel.text = pair.dailyPercent?.dailyPercentFormattedString
    volumeLabel.text = pair.volume?.formattedString
    numeratorSymbolLabel.text = pair.numeratorSymbol
    
    dailyPercentLabel.textColor = pair.dailyPercent?.color
  }
  
  // MARK: - Action Methods
  @objc private func favoriteButtonTapped() {
    favoriteButtonAction?()
  }
  
  // MARK: - Helper Methods
  private func createLabel(font: UIFont, textColor: UIColor) -> UILabel {
    let label = UILabel()
    label.font = font
    label.textColor = textColor
    label.sizeToFit()
    return label
  }
}
