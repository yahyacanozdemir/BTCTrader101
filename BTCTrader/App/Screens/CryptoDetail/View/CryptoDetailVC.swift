//
//  CryptoDetailVC.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

class CryptoDetailVC: BaseVC<CryptoDetailContentView> {
  
  var coordinator: CryptoDetailCoordinator?
  var pageTitle: String?
  
  override func bind() {
    if let navBar = selectedNavBar as? AppNavBar {
      navBar.setTitle(title: pageTitle ?? "")
      
      navBar.onTapBack = { [weak self] in
        self?.coordinator?.pop()
      }
    }
  }
}
