//
//  CVHeader.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

class CVHeaderView: UICollectionReusableView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 28)
    label.textColor = .btcTurkWhite
    return label
  }()
  
  private func setupSubviews() {
    backgroundColor = .btcTurkDark
    addSubview(titleLabel)
  }
  
  private func setupConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().offset(4)
      make.bottom.equalToSuperview().offset(-16)
    }
  }
}
