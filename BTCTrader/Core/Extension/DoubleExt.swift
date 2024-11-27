//
//  DoubleExt.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

extension Double {
  var color: UIColor {
    return self < 0 ? .btcTurkRed : .btcTurkGreen
  }
  
  var dailyPercentFormattedString: String {
    let formatted = String(format: "%.2f", abs(self))
    return "%" + formatted
  }
  
  var formattedString: String {
    let formatted = String(self)
    return formatted.replacingOccurrences(of: ".", with: ",")
  }
}
