//
//  BTCTraderTests.swift
//  BTCTraderTests
//
//  Created by Yahya Can Özdemir on 27.11.2024.
//

import XCTest
@testable import BTCTrader

final class BTCTraderTests: XCTestCase {
  
  private var mockService: MockDiscoverService!
  private var viewModel: DiscoverViewModel!
  private var events: [DiscoverViewModel.DiscoverEventType] = []
  
  override func setUp() {
    super.setUp()
    self.viewModel = createViewModel()
    viewModel.eventTrigger = { event in
      self.events.append(event)
    }
  }
  
  override func tearDown() {
    viewModel = nil
    mockService = nil
    events = []
    super.tearDown()
  }
  
  private func createViewModel() -> DiscoverViewModel {
    var service = MockDiscoverService()
    service.mockPairs = PairsEntity(data: [Pair(pair: "BTC/USDT", isFavorite: false)])
    //TODO: open for failure test
    //service.shouldReturnError = true
    let useCase = DiscoverUseCase(repository: DiscoverRepository(service: service))
    let viewModel = DiscoverViewModel(useCase: useCase)
    return viewModel
  }
  
  func testFetchPairs_Success() async {
    XCTAssertEqual(events.count, 0)
    await fetchPairs()
    
    XCTAssertEqual(events, [.loading(true), .loading(false), .favoritesUpdated, .pairsUpdated])
    XCTAssertEqual(viewModel.allCryptos.count, 1)
    XCTAssertEqual(viewModel.allCryptos.first?.pair, "BTC/USDT")
  }
  
  func testFetchPairs_Failure() async {
    await fetchPairs()
    
    XCTAssertTrue(events.contains{ $0 == .loading(true)})
    XCTAssertTrue(events.contains{ $0 == .loading(false)})
    XCTAssertEqual(events.count, 3)
    XCTAssertTrue(events.contains { if case .showError(let error) = $0 { return error == "Api okunurken hata" } else { return false } })
  }
  
  func testToggleFavorite_Success() async {
    await fetchPairs()
    
    // favorite true
    toggleFavorite(at: 0)
    
    XCTAssertEqual(viewModel.favoriteCryptos.count, 1)
    XCTAssertTrue(viewModel.allCryptos.first?.isFavorite == true)
    
    // favorite false
    toggleFavorite(at: 0)
    
    XCTAssertEqual(viewModel.favoriteCryptos.count, 0)
    XCTAssertTrue(viewModel.allCryptos.first?.isFavorite == false)
  }
}

//MARK: Helper Functions

extension BTCTraderTests {
  func fetchPairs() async {
    await withCheckedContinuation { continuation in
      viewModel.fetchPairs(withContentLoading: true)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        continuation.resume()
      }
    }
  }
  
  func toggleFavorite(at index: Int) {
    let pair = viewModel.allCryptos[index]
    viewModel.toggleFavorite(pair: pair, indexPath: IndexPath(row: index, section: 0))
  }
}


//MARK: Mock Service

struct MockDiscoverService: DiscoverServiceProtoocol {
  var shouldReturnError = false
  var mockPairs: PairsEntity?
  
  func fetchPairs(completion: @escaping (DiscoverResponseType) -> Void) {
    if shouldReturnError {
      completion(.fetchPairsFail(error: "Api okunurken hata"))
    } else {
      completion(.fetchPairsSuccess(pairs: mockPairs))
    }
  }
}
