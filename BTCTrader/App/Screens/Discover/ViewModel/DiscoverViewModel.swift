//
//  DiscoverViewModel.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import Foundation
import UIKit

final class DiscoverViewModel: BaseViewModel {
  
  // MARK: - Enums
  
  enum DiscoverEventType {
    case favoritesUpdated
    case loading(Bool)
    case allCryptosUpdated
    case showError(String)
  }
  
  typealias EventType = DiscoverEventType
  
  // MARK: - Properties
  
  var eventTrigger: ((EventType) -> Void)?
  private var useCase: DiscoverUseCase
  private(set) var favoriteCryptos: [Pair] = []
  private(set) var allCryptos: [Pair] = []
  
  // MARK: - Initialization
  
  init(useCase: DiscoverUseCase) {
    self.useCase = useCase
  }
  
  // MARK: - Public Methods
  
  func start() {
    fetchPairs()
  }
  
  func fetchPairs() {
    eventTrigger?(.loading(true))
    useCase.execute { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .fetchPairsSuccess(let pairs):
        guard let pairItems = pairs?.data else { return }
        self.allCryptos = pairItems
        self.loadFavorites()
      case .fetchPairsFail(let errorMsg):
        self.eventTrigger?(.loading(false))
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
}

// MARK: - Favorite Logic

extension DiscoverViewModel {
  func toggleFavorite(pair: Pair, indexPath: IndexPath) {
    if let index = favoriteCryptos.firstIndex(where: { $0.pair == pair.pair }) {
      favoriteCryptos.remove(at: index)
    } else {
      var updatedPair = pair
      updatedPair.isFavorite = true
      favoriteCryptos.append(updatedPair)
    }
    
    allCryptos[indexPath.item].isFavorite = !(pair.isFavorite ?? false)
    saveFavoritesToLocal(favoriteCryptos.map { $0.pair ?? "" })
    
    eventTrigger?(.favoritesUpdated)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
      self.eventTrigger?(.allCryptosUpdated)
    }
  }
  
  private func loadFavorites() {
    DispatchQueue.global(qos: .background).async {
      let localFavoritePairs = self.loadFavoritesFromLocal()
      
      self.allCryptos = self.allCryptos.map { pair in
        var updatedPair = pair
        updatedPair.isFavorite = localFavoritePairs.contains(pair.pair ?? "")
        return updatedPair
      }
      
      let newFavorites = self.allCryptos.filter { $0.isFavorite == true }
      
      DispatchQueue.main.async {
        self.favoriteCryptos = newFavorites
        self.eventTrigger?(.loading(false))
        self.eventTrigger?(.favoritesUpdated)
        self.eventTrigger?(.allCryptosUpdated)
      }
    }
  }

  
  private func saveFavoritesToLocal(_ pairs: [String]) {
    UserDefaults.standard.set(pairs, forKey: "favoritePairs")
  }
  
  private func loadFavoritesFromLocal() -> [String] {
    UserDefaults.standard.stringArray(forKey: "favoritePairs") ?? []
  }
}
