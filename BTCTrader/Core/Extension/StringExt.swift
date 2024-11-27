//
//  StringExt.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

extension String {
  func width(with font: UIFont) -> CGFloat {
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    let size = (self as NSString).boundingRect(
      with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
      options: .usesLineFragmentOrigin,
      attributes: attributes,
      context: nil
    ).size
    return size.width
  }
}
