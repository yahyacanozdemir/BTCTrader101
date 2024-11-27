//
//  UICollectionViewExt.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

extension UICollectionView {
  
  func register(with cellClass: AnyClass) {
    register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.self))
  }
  
  func dequeueCell<T>(withClassAndIdentifier _: T.Type, for indexPath: IndexPath) -> T {
    dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
  }
}
