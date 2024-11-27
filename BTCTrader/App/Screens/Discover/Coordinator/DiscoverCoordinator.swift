//
//  DiscoverCoordinator.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

class DiscoverCoordinator: Coordinator {
  
  private var navigationController: BaseNavigationController
  
  required init(navigationController: BaseNavigationController) {
    self.navigationController = navigationController
  }
  
  func start(navigationType _: NavigationType) { }
  
  func start() {
    let useCase = DiscoverUseCase(repository: DiscoverRepository(service: DiscoverService()))
    let viewModel = DiscoverViewModel(useCase: useCase)
    let view = DiscoverContentView(viewModel: viewModel)
    let vc = DiscoverVC(contentView: view)
    view.inject()
    vc.coordinator = self
    navigationController.setViewControllers([vc], animated: false)
  }
}

extension DiscoverCoordinator {
  func navigateToCryptoDetail(_ cryptoDetail: Pair) {
    let cryptoDetailCoordinator = CryptoDetailCoordinator(navigationController: navigationController)
    cryptoDetailCoordinator.start(cryptoDetail)
  }
}
