//
//  DiscoverService.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

protocol CryptoGraphServiceProtoocol {
  func fetchGraphDetail(params: CryptoGraphParameters, completion: @escaping(CryptoGraphResponseType) -> Void)
}

enum CryptoGraphResponseType{
  case fetchGraphSuccess(graphDetail: CryptoGraphEntity?), fetchGraphFail(error: String?)
}

struct CryptoGraphService: CryptoGraphServiceProtoocol {
  func fetchGraphDetail(params: CryptoGraphParameters, completion: @escaping (CryptoGraphResponseType) -> Void) {
    let request = BaseRequest(
      endpoint:
          .kLine(
            symbol: params.symbol,
            resolution: params.resolution,
            from: params.from,
            to: params.to
          ),
      method: .get
)
    
    NetworkManager.shared.sendRequest(request: request, responseType: CryptoGraphEntity()) { result in
      switch result {
      case .success(let response):
        completion(.fetchGraphSuccess(graphDetail: response))
      case .failure(let error):
        completion(.fetchGraphFail(error: error.localizedDescription))
      }
    }
  }
}

struct CryptoGraphParameters {
  var symbol: String
  var resolution, from, to: Int
}

