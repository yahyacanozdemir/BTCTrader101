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
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "tr_TR") // Türkçe yerelleştirme
    return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
  }
}


extension Int {
  func formattedDateString(format: String = "dd MMM yyyy, HH:mm") -> String {
    let timeInterval = TimeInterval(self)
    let date = Date(timeIntervalSince1970: timeInterval)
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "tr_TR") // Türkçe format için
    formatter.dateFormat = format
    return formatter.string(from: date)
  }
}
