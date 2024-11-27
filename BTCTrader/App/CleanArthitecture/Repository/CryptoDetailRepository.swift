//
//  CryptoDetailRepository.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

protocol CryptoDetailRepositoryProtocol {
  func getGraphDetail(params: CryptoGraphParameters, completion: @escaping (CryptoGraphResponseType) -> ())
}

struct CryptoDetailRepository: CryptoDetailRepositoryProtocol {

  private let service: CryptoGraphServiceProtoocol
  
  init(service: CryptoGraphServiceProtoocol = CryptoGraphService()) {
    self.service = service
  }
  
  func getGraphDetail(params: CryptoGraphParameters, completion: @escaping (CryptoGraphResponseType) -> ()) {
    service.fetchGraphDetail(params: params, completion: completion)
  }
}
