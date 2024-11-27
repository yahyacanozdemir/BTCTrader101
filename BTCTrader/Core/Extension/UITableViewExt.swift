//
//  UITableViewExt.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

extension UITableView {

  func register(with cellClass: AnyClass) {
    register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
  }

  func dequeueCell<T>(withClassAndIdentifier _: T.Type, for indexPath: IndexPath) -> T {
    dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
  }
}
