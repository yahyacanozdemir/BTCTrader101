//
//  CryptoDetailUseCase.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import Foundation

protocol CryptoDetailUseCaseProtocol {
  func fetchDailyChanges(completion: @escaping (CryptoGraphResponseType) -> ())
}

struct CryptoDetailUseCase: CryptoDetailUseCaseProtocol {
  
  private var graphSericeParams: CryptoGraphParameters
  private let repository: CryptoDetailRepositoryProtocol
  
  init(repository: CryptoDetailRepositoryProtocol = CryptoDetailRepository(), graphSericeParams: CryptoGraphParameters) {
    self.repository = repository
    self.graphSericeParams = graphSericeParams
  }
  
  func fetchLast1HourChanges(completion: @escaping (CryptoGraphResponseType) -> ()) {
    let oneHour = Date().xHourAgoTimeStamp(1)
    var params = graphSericeParams
    params.from = oneHour
    repository.getGraphDetail(params: params, completion: completion)
  }
  
  func fetchDailyChanges(completion: @escaping (CryptoGraphResponseType) -> ()) {
    let oneDay = Date().xHourAgoTimeStamp(24)
    var params = graphSericeParams
    params.from = oneDay
    repository.getGraphDetail(params: params, completion: completion)
  }
  
  func fetchWeeklyChanges(completion: @escaping (CryptoGraphResponseType) -> ()) {
    let oneWeek = Date().xHourAgoTimeStamp(7 * 24)
    var params = graphSericeParams
    params.from = oneWeek
    repository.getGraphDetail(params: params, completion: completion)
  }
  
  func fetchMonthlyChanges(completion: @escaping (CryptoGraphResponseType) -> ()) {
    let oneMonth = Date().xHourAgoTimeStamp(30 * 24)
    var params = graphSericeParams
    params.from = oneMonth
    repository.getGraphDetail(params: params, completion: completion)
  }
}
