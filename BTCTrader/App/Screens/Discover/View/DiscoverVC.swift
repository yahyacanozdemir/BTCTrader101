//
//  DiscoverVC.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

class DiscoverVC: BaseVC<DiscoverContentView> {
  
  var coordinator: DiscoverCoordinator?
  
  override func bind() {
    contentView?.delegate = self
  }
}

extension DiscoverVC: DiscoverContentViewProtocol {
  func navigateToCryptoDetailPage(_ cryptoDetail: Pair) {
    coordinator?.navigateToCryptoDetail(cryptoDetail)
  }
}
