import UIKit

class FavoriteCell: BaseCollectionViewCell {
  
  // MARK: - Properties
  
  var favoriteButtonAction: (() -> Void)?
  
  var cellData: Pair? {
    didSet { updateUI() }
  }
  
  // MARK: - UI Components
  
  private lazy var nameLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .btcTurkWhite)
  private lazy var lastPriceLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .btcTurkWhite)
  private lazy var dailyPercentLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .btcTurkRed)
  private lazy var controller: UIContextMenuInteraction = {
    let controller = UIContextMenuInteraction(delegate: self)
    return controller
  }()
  
  // MARK: - Layout
  
  override func setupSubviews() {
    contentView.backgroundColor = .btcTurkDarkBlue
    contentView.layer.cornerRadius = 8
    
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
    self.addGestureRecognizer(longPressGesture)
    
    [nameLabel, lastPriceLabel, dailyPercentLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  override func setupConstraints() {
    nameLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(4)
      make.bottom.equalTo(lastPriceLabel.snp.top).offset(-4)
    }
    
    lastPriceLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(4)
    }
    
    dailyPercentLabel.snp.makeConstraints { make in
      make.top.equalTo(lastPriceLabel.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview().inset(4)
    }
  }
  
  override func updateUI() {
    guard let pair = cellData else { return }
    nameLabel.text = pair.pair?.formatPair()
    lastPriceLabel.text = pair.last?.formattedString
    dailyPercentLabel.text = pair.dailyPercent?.dailyPercentFormattedString
    dailyPercentLabel.textColor = pair.dailyPercent?.color
  }
  
  // MARK: - Helper Methods
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
  -> UICollectionViewLayoutAttributes
  {
    let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
    let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    layoutAttributes.size.height = ceil(size.height)
    return layoutAttributes
  }
  
  private func createLabel(font: UIFont, textColor: UIColor) -> UILabel {
    let label = UILabel()
    label.font = font
    label.textColor = textColor
    label.sizeToFit()
    return label
  }
  
  // MARK: - Long Press Gesture Action
  
  @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
    if gesture.state == .began {
      if let view = gesture.view {
        view.addInteraction(controller)
        view.becomeFirstResponder()
      }
    }
  }
}

extension FavoriteCell: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
      let removeAction = UIAction(title: "Remove from favorite", image: nil) { _ in
        self.favoriteButtonAction?()
      }
      return UIMenu(title: "", children: [removeAction])
    }
  }
}
