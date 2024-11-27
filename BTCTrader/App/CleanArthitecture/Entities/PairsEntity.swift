//
//  PairsEntity.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 2.11.2024.
//

struct PairsEntity: Codable {
  var data: [Pair]?
}

struct Pair: Codable {
  var pair, pairNormalized, numeratorSymbol: String?
  var volume, last, dailyPercent: Double?
  var isFavorite: Bool?
}
