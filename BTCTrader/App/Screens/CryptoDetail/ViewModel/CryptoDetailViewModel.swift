//
//  CryptoDetailViewModel.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

final class CryptoDetailViewModel: BaseViewModel {
  
  // MARK: - Enum
  
  enum CryptoDetailEventType {
    case loading(Bool)
    case graphUpdated(CryptoGraphEntity?)
    case showError(String)
  }
  
  // MARK: - Properties
  
  typealias EventType = CryptoDetailEventType
  var eventTrigger: ((EventType) -> Void)?
  
  private var useCase: CryptoDetailUseCase
  
  // MARK: - Initialization
  
  init(useCase: CryptoDetailUseCase) {
    self.useCase = useCase
  }
  
  // MARK: - Public Methods
  
  func start() {
    fetchGraphDetail()
  }
  
  func fetchGraphDetail() {
    eventTrigger?(.loading(true))
    useCase.execute(completion: { [weak self] result in
      self?.eventTrigger?(.loading(false))
      switch result {
      case .fetchGraphSuccess(let detail):
        self?.eventTrigger?(.graphUpdated(detail))
      case .fetchGraphFail(let errorMsg):
        self?.eventTrigger?(.showError(errorMsg ?? "Veri çekilirken hata meydana geldi"))
      }
    })
  }
}

