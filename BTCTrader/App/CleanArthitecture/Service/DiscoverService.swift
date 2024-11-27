//
//  DiscoverService.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

protocol DiscoverServiceProtoocol {
  func fetchPairs(completion: @escaping(DiscoverResponseType) -> Void)
}

enum DiscoverResponseType{
  case fetchPairsSuccess(pairs: PairsEntity?), fetchPairsFail(error: String?)
}

class DiscoverService: DiscoverServiceProtoocol {
  func fetchPairs(completion: @escaping (DiscoverResponseType) -> Void) {
    let request = BaseRequest(
      endpoint: .pairs,
      method: .get)
    
    NetworkManager.shared.sendRequest(request: request, responseType: PairsEntity()) { result in
      switch result {
      case .success(let response):
        completion(.fetchPairsSuccess(pairs: response))
      case .failure(let error):
        completion(.fetchPairsFail(error: error.localizedDescription))
      }
    }
  }
}
