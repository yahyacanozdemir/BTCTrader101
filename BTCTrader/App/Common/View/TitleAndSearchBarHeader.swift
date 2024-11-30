//
//  TitleAndSearchBarHeader.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 28.11.2024.
//

import UIKit

class TitleAndSearchBarHeader: BaseView {
  
  // MARK: - Properties
  private var title: String
  private var searchBarPlaceHolder: String?
  var searchBarUpdated: ((String) -> ())?
  
  
  // MARK: - Initialization
  init(title: String, searchBarPlaceHolder: String? = nil) {
    self.title = title
    self.searchBarPlaceHolder = searchBarPlaceHolder
    super.init()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Components
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .boldSystemFont(ofSize: 28)
    titleLabel.textColor = .btcTurkWhite
    return titleLabel
  }()
  
  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.backgroundColor = .btcTurkDark.withAlphaComponent(0.4)
    searchBar.keyboardType = .asciiCapable
    searchBar.showsBookmarkButton = false
    searchBar.searchBarStyle = .minimal
    searchBar.searchTextField.textColor = .btcTurkWhite
    searchBar.searchTextField.font = .boldSystemFont(ofSize: 12)
    searchBar.placeholder = searchBarPlaceHolder ?? "Search"
    searchBar.layer.masksToBounds = true
    searchBar.layer.cornerRadius = 16
    searchBar.delegate = self
    
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let closeButton = UIBarButtonItem(
      title: "Close",
      style: .done,
      target: self,
      action: #selector(dismissKeyboard)
    )
    toolbar.setItems([closeButton], animated: false)
    toolbar.tintColor = .btcTurkWhite
    
    searchBar.inputAccessoryView = toolbar
    return searchBar
  }()
  
  // MARK: - Layout
  override func setupSubviews() {
    backgroundColor = .btcTurkDark
    addSubview(titleLabel)
    addSubview(searchBar)
  }
  
  override func setupConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
      make.height.equalTo(28)
    }
    
    searchBar.snp.makeConstraints { make in
      make.centerX.equalToSuperview().offset(64)
      make.centerY.equalToSuperview()
      make.height.equalTo(28)
      make.trailing.equalToSuperview().inset(10)
    }
  }
  
  @objc func dismissKeyboard() {
    searchBar.resignFirstResponder() // Klavye kapanır
  }
}

extension TitleAndSearchBarHeader: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let currentText = searchBar.text,
          let textRange = Range(range, in: currentText) else {
      return true
    }
    
    let newText = currentText.replacingCharacters(in: textRange, with: text)
    searchBarUpdated?(newText)
    return true
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      searchBarUpdated?("")
    }
  }
}
