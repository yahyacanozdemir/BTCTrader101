//
//  DiscoverViewModel.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

final class DiscoverViewModel: BaseViewModel {
  
  // MARK: - Enums
  
  enum DiscoverEventType: Equatable {
    case favoritesUpdated
    case loading(Bool)
    case pairsUpdated
    case showError(String)
  }
  
  typealias EventType = DiscoverEventType
  
  // MARK: - Properties
  
  var eventTrigger: ((EventType) -> Void)?
  private var useCase: DiscoverUseCase
  
  private(set) var favoriteCryptos: [Pair] = []
  private(set) var allCryptos: [Pair] = []
  private(set) var filteredCryptos: [Pair] = []
  
  // MARK: - Initialization
  
  init(useCase: DiscoverUseCase) {
    self.useCase = useCase
  }
  
  // MARK: - Public Methods
  
  func start() {
    fetchPairs(withContentLoading: true)
  }
  
  func fetchPairs(withContentLoading: Bool) {
    withContentLoading ? eventTrigger?(.loading(true)) : ()
    
    useCase.execute { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .fetchPairsSuccess(let pairs):
        guard let pairItems = pairs?.data else { return }
        self.allCryptos = pairItems
        self.loadFavorites()
      case .fetchPairsFail(let errorMsg):
        withContentLoading ? eventTrigger?(.loading(false)) : ()
        self.eventTrigger?(.showError(errorMsg ?? "Veri çekilirken hata meydana geldi"))
      }
    }
  }
}

// MARK: - Helper Functions

extension DiscoverViewModel {
  
  func isLastPairCell(indexPath: IndexPath) -> Bool {
    indexPath.row == allCryptos.count - 1
  }
  
  func calculateFavoriteCellWidth(indexPath: IndexPath) -> CGSize {
    let pair = favoriteCryptos[indexPath.row]
    let nameWidth = pair.pair?.width(with: UIFont.boldSystemFont(ofSize: 14)) ?? 0
    let dailyPercentWidth = pair.last?.formattedString.width(with: UIFont.boldSystemFont(ofSize: 14)) ?? 0
    let width = max(nameWidth, dailyPercentWidth)
    return CGSize(width: width + 24, height: 80)
  }
  
  private func allCryptosUpdated() {
    eventTrigger?(.favoritesUpdated)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
      self.eventTrigger?(.pairsUpdated)
    }
  }
}

// MARK: - Favorite Logic

extension DiscoverViewModel {
  
  func toggleFavorite(pair: Pair) {
    if let index = favoriteCryptos.firstIndex(where: { $0.pair == pair.pair }) {
      favoriteCryptos.remove(at: index)
    } else {
      var updatedPair = pair
      updatedPair.isFavorite = true
      favoriteCryptos.append(updatedPair)
    }
    
    if !allCryptos.isEmpty {
      if let index = allCryptos.firstIndex(where: { $0.pair == pair.pair }) {
        allCryptos[index].isFavorite = !(pair.isFavorite ?? false)
      }
    }
    
    if !filteredCryptos.isEmpty {
      if let index = filteredCryptos.firstIndex(where: { $0.pair == pair.pair }) {
        filteredCryptos[index].isFavorite = !(pair.isFavorite ?? false)
      }
    }
    
    saveFavoritesToLocal(favoriteCryptos.map { $0.pair ?? "" })
    
    self.allCryptosUpdated()
  }
  
  private func loadFavorites() {
    DispatchQueue.global(qos: .background).async {
      let localFavoritePairs = self.loadFavoritesFromLocal()
      
      self.allCryptos = self.allCryptos.map { pair in
        var updatedPair = pair
        updatedPair.isFavorite = localFavoritePairs.contains(pair.pair ?? "")
        return updatedPair
      }
      
      var newFavorites = self.allCryptos.filter { $0.isFavorite == true }
      
      //New favorites sorting for possible re-positioning case
      newFavorites.sort { pair1, pair2 in
        guard let pair1String = pair1.pair,
              let pair2String = pair2.pair,
              let index1 = localFavoritePairs.firstIndex(of: pair1String),
              let index2 = localFavoritePairs.firstIndex(of: pair2String) else {
          return false
        }
        return index1 < index2
      }
      
      DispatchQueue.main.async {
        self.favoriteCryptos = newFavorites
        self.eventTrigger?(.loading(false))
        self.allCryptosUpdated()
      }
    }
  }
  
  func clearFavorites() {
    allCryptos.forEach { pair in
      if let index = allCryptos.firstIndex(where: { $0.pair == pair.pair }) {
        allCryptos[index].isFavorite = false
      }
    }
    
    filteredCryptos.forEach { pair in
      if let index = filteredCryptos.firstIndex(where: { $0.pair == pair.pair }) {
        filteredCryptos[index].isFavorite = false
      }
    }
    
    favoriteCryptos = []
    saveFavoritesToLocal([])
    allCryptosUpdated()
  }
  
  func repositionFavorites(sourceIndex: Int, destinationIndex: Int) {
    let draggedPair = favoriteCryptos.remove(at: sourceIndex)
    favoriteCryptos.insert(draggedPair, at: destinationIndex)
  }
  
  func didRepositionFavorites() {
    saveFavoritesToLocal([])
    saveFavoritesToLocal(favoriteCryptos.map { $0.pair ?? "" })
  }
  
  private func saveFavoritesToLocal(_ pairs: [String]) {
    UserDefaults.standard.set(pairs, forKey: "favoritePairs")
  }
  
  private func loadFavoritesFromLocal() -> [String] {
    UserDefaults.standard.stringArray(forKey: "favoritePairs") ?? []
  }
}

//MARK: - Filter Logic

extension DiscoverViewModel {
  func filterPairs(with searchText: String) {
    guard !searchText.isEmpty else {
      filteredCryptos = []
      eventTrigger?(.pairsUpdated)
      return
    }
    
    filteredCryptos = allCryptos.filter {
      $0.pair?.lowercased().contains(searchText.lowercased()) ?? false
    }
    eventTrigger?(.pairsUpdated)
  }
  
  func returnShowingPairsData() -> [Pair] {
    return filteredCryptos.isEmpty ? (allCryptos.isEmpty ? [] : allCryptos) : filteredCryptos
  }
}


//MARK: FOR TESTING
extension DiscoverViewModel {
  func setAllCryptos(_ cryptos: [Pair]) {
    self.allCryptos = cryptos
  }
}
