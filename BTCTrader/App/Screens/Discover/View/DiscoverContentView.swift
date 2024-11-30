//
//  DiscoverContentView.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

protocol DiscoverContentViewProtocol: AnyObject {
  func navigateToCryptoDetailPage(_ cryptoDetail: Pair)
}

class DiscoverContentView: BaseView {
  
  // MARK: - Properties
  
  private let viewModel: DiscoverViewModel
  weak var delegate: DiscoverContentViewProtocol?
  
  // MARK: - Initialization
  
  init(viewModel: DiscoverViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  func inject() {
    viewModel.start()
    bind()
  }
  
  override func bind() {
    viewModel.eventTrigger = { [weak self] type in
      DispatchQueue.main.async {
        switch type {
        case .favoritesUpdated:
          self?.changeFavoritesVisibility()
        case .loading(let isShow):
          self?.contentLoadingView.isHidden = !isShow
        case .pairsUpdated:
          self?.updateUI()
        case .showError(let message):
          print("Error: \(message)") // Handle error display
        }
      }
    }
  }
  
  // MARK: - UI Components
  
  private lazy var favoritesCVTitleView: TitleAndButtonHeader = {
    let view = TitleAndButtonHeader(title: "Favorites", buttonTitle: "Clear")
    view.isHidden = true
    view.buttonTapHandler = { [weak self] in
      self?.viewModel.clearFavorites()
    }
    return view
  }()
  
  private lazy var favoritesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    layout.minimumLineSpacing = 10
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(with: FavoriteCell.self)
    cv.showsHorizontalScrollIndicator = false
    cv.dragDelegate = self
    cv.dropDelegate = self
    cv.backgroundColor = .clear
    cv.delegate = self
    cv.dataSource = self
    cv.isHidden = true
    return cv
  }()
  
  private lazy var pairsCVTitleView: TitleAndSearchBarHeader = {
    let headerView = TitleAndSearchBarHeader(title: "Pairs", searchBarPlaceHolder: "Search any pair")
    headerView.searchBarUpdated = { [weak self] text in
      self?.viewModel.filterPairs(with: text)
    }
    return headerView
  }()
  
  private lazy var pairsTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(with: PairCell.self)
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.separatorColor = .clear
    tableView.backgroundColor = .clear
    tableView.delegate = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }()
  
  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .btcTurkWhite
    refreshControl
      .addTarget(self, action: #selector(refreshPairs), for: .valueChanged)
    return refreshControl
  }()
  
  private lazy var contentLoadingView: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .btcTurkWhite
    indicator.startAnimating()
    return indicator
  }()
  
  // MARK: - Layout
  
  override func setupSubviews() {
    pairsTableView.addSubview(refreshControl)
    [favoritesCVTitleView, favoritesCollectionView, pairsTableView, contentLoadingView].forEach { addSubview($0) }
  }
  
  override func setupConstraints() {
    favoritesCVTitleView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.horizontalEdges.equalToSuperview().inset(8)
    }
    
    favoritesCollectionView.snp.makeConstraints { make in
      make.top.equalTo(favoritesCVTitleView.snp.bottom).offset(16)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalTo(pairsTableView.snp.top).offset(-16)
      make.height.equalTo(80)
    }
    
    pairsTableView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview().inset(8)
    }
    
    contentLoadingView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.height.equalTo(100)
    }
  }
  
  // MARK: - UI Update
  
  override func updateUI() {
    DispatchQueue.main.async {
      self.refreshControl.endRefreshing()
      self.favoritesCollectionView.reloadData()
      self.pairsTableView.reloadData()
    }
  }
  
  @objc
  func refreshPairs() {
    viewModel.fetchPairs(withContentLoading: false)
  }
  
  private func changeFavoritesVisibility() {
    let isFavoritesEmpty = viewModel.favoriteCryptos.isEmpty
    favoritesCVTitleView.isHidden = isFavoritesEmpty
    favoritesCollectionView.isHidden = isFavoritesEmpty
    
    favoritesCollectionView.snp.updateConstraints { make in
      make.height.equalTo(isFavoritesEmpty ? 0 : 80)
      make.bottom.equalTo(pairsTableView.snp.top).offset(isFavoritesEmpty ? 0 : -16)
    }
    
    if isFavoritesEmpty {
      pairsTableView.snp.makeConstraints { make in
        make.top.equalToSuperview()
      }
    } else {
      pairsTableView.snp.removeConstraints()
      pairsTableView.snp.makeConstraints { make in
        make.leading.trailing.bottom.equalToSuperview().inset(8)
      }
    }
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DiscoverContentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.favoriteCryptos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withClassAndIdentifier: FavoriteCell.self, for: indexPath)
    let pair = viewModel.favoriteCryptos[indexPath.item]
    cell.cellData = pair
    cell.favoriteButtonAction = { [weak self] in
      self?.viewModel.toggleFavorite(pair: pair)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.navigateToCryptoDetailPage(viewModel.favoriteCryptos[indexPath.item])
  }
  
  func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    viewModel.calculateFavoriteCellWidth(indexPath: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let itemIdentifier = "\(indexPath.item)"
    let itemProvider = NSItemProvider(object: itemIdentifier as NSString)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    dragItem.localObject = indexPath.item
    return [dragItem]
  }
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
    
    for item in coordinator.items {
      if let sourceIndex = item.dragItem.localObject as? Int {
        collectionView.performBatchUpdates({
            viewModel.repositionFavorites(sourceIndex: sourceIndex, destinationIndex: destinationIndexPath.item)
            
            collectionView.deleteItems(at: [IndexPath(item: sourceIndex, section: 0)])
            collectionView.insertItems(at: [destinationIndexPath])
          })
        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        viewModel.didRepositionFavorites()
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    return session.localDragSession != nil
  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DiscoverContentView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.returnShowingPairsData().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(withClassAndIdentifier: PairCell.self, for: indexPath)
    let pair = viewModel.returnShowingPairsData()[indexPath.row]
    cell.cellData = pair
    
    cell.favoriteButtonAction = { [weak self] in
      self?.viewModel.toggleFavorite(pair: pair)
    }
    
    cell.isLastCell = viewModel.isLastPairCell(indexPath: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    64
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.navigateToCryptoDetailPage(viewModel.allCryptos[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return pairsCVTitleView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 48
  }
}
