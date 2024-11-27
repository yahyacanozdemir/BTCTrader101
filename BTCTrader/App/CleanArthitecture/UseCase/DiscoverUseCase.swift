//
//  DiscoverUseCase.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import Foundation

protocol DiscoverUseCaseProtocol {
  func execute(completion: @escaping (DiscoverResponseType) -> ())
}

class DiscoverUseCase: DiscoverUseCaseProtocol {

  private let repository: DiscoverRepositoryProtocol
  
  init(repository: DiscoverRepositoryProtocol = DiscoverRepository()) {
    self.repository = repository
  }
  
  func execute(completion: @escaping (DiscoverResponseType) -> ()) {
    repository.getPairs(completion: completion)
  }
}
