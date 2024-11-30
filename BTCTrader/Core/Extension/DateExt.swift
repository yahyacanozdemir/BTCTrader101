//
//  DateExt.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 29.11.2024.
//

import Foundation

extension Date {  
  func xHourAgoTimeStamp(_ hour: Int) -> Int {
    return xMinuteAgoTimeStamp(hour * 60)
  }
  
  func xMinuteAgoTimeStamp(_ minute: Int) -> Int {
    return Int(
      Date()
        .addingTimeInterval(
          TimeInterval(-(minute) * 60)
        ).timeIntervalSince1970
    )
  }
}
