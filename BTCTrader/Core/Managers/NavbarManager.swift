//
//  NavbarManager.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

enum NavbarManager {

  static func placeNavbar(baseVC: UIViewController) -> BaseView? {
    switch baseVC {
    case baseVC as? CryptoDetailVC: return AppNavBar()
    default: return nil
    }
  }
}
