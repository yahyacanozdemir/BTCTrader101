//
//  Endpoint.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import Foundation

enum Endpoint {
  case pairs
  case kLine(symbol: String, resolution: Int, from: Int, to: Int)
  
  private var path: String {
    switch self {
    case .pairs: "https://api.btcturk.com/api/v2/ticker"
    case .kLine(let symbol, let resolution, let from, let to): "https://graph-api.btcturk.com/v1/klines/history?symbol=\(symbol)&resolution=\(resolution)&from=\(from)&to=\(to)"
    }
  }
  
  var url: URL? {
    URL(string: path)
  }
}
