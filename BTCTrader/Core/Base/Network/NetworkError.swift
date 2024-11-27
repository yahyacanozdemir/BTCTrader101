//
//  NetworkError.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

enum NetworkError: Error {
  case requestFailed(Error)
  case parse(Error)
  case unknown

  var message: String {
    switch self {
    case .requestFailed(let error):
      return error.localizedDescription
    case .parse(let error):
      return error.localizedDescription
    default:
      return "Bir sorun oluştu. Biraz sonra tekrar deneyiniz."
    }
  }
}
