//
//  BaseView.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

class BaseView: UIView, BindableLayout {
  
  // MARK: - Initialization
  
  init() {
    super.init(frame: .zero)
    accessibilityIdentifier = String(describing: type(of: self))
    setupUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  // MARK: - Lifecycle Methods
  
  func viewDidLoad() {}

  func viewDidAppear() { }

  func viewDidDisappear() { }

  func viewWillAppear() {}

  func viewWillDisappear() { }

  func viewDidKill() {
    subviews.forEach { subview in
      if let view = subview as? BaseView {
        view.viewDidKill()
      }
    }
  }
  
  // MARK: - Layoutable

  func bind() {}

  final func setupUI() {
    setupSubviews()
    setupConstraints()
  }
  
  // MARK: - Subview Setup & Constraints

  func setupSubviews() { }

  func setupConstraints() { }  
  
  func updateUI() { }
}
