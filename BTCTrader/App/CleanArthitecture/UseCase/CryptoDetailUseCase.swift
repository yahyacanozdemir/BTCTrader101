//
//  CryptoDetailUseCase.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

protocol CryptoDetailUseCaseProtocol {
  func execute(completion: @escaping (CryptoGraphResponseType) -> ())
}

struct CryptoDetailUseCase: CryptoDetailUseCaseProtocol {
  
  private var graphSericeParams: CryptoGraphParameters
  private let repository: CryptoDetailRepositoryProtocol
  
  init(repository: CryptoDetailRepositoryProtocol = CryptoDetailRepository(), graphSericeParams: CryptoGraphParameters) {
    self.repository = repository
    self.graphSericeParams = graphSericeParams
  }
  
  func execute(completion: @escaping (CryptoGraphResponseType) -> ()) {
    repository.getGraphDetail(params: graphSericeParams, completion: completion)
  }
}
