//
//  DiscoverRepository.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

protocol DiscoverRepositoryProtocol {
  func getPairs(completion: @escaping (DiscoverResponseType) -> ())
}

class DiscoverRepository: DiscoverRepositoryProtocol {

  private let service: DiscoverServiceProtoocol
  
  init(service: DiscoverServiceProtoocol = DiscoverService()) {
    self.service = service
  }
  
  func getPairs(completion: @escaping (DiscoverResponseType) -> ()) {
    service.fetchPairs(completion: completion)
  }
}
