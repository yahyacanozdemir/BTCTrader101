//
//  CryptoDetailCoordinator.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import Foundation

class CryptoDetailCoordinator: BaseCoordinator {
  
  func start(_ cryptoDetail: Pair) {
    
    let now = Date().xMinuteAgoTimeStamp(1)
    let yesterday = Date().xHourAgoTimeStamp(24)
    
    let graphSericeParams = CryptoGraphParameters(
      symbol: cryptoDetail.pair ?? "",
      resolution: 1,
      from: Int(yesterday),
      to: Int(now))
      
    let useCase = CryptoDetailUseCase(
      repository: CryptoDetailRepository(service: CryptoGraphService()),
      graphSericeParams: graphSericeParams
    )
    let viewModel = CryptoDetailViewModel(useCase: useCase)
    
    let view = CryptoDetailContentView(viewModel: viewModel)
    view.inject()
    
    let vc = CryptoDetailVC(contentView: view)
    vc.pageTitle = cryptoDetail.pair
    vc.coordinator = self
    
    navigateTo(vc)
  }
}
