//
//  CryptoDetailViewModel.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import DGCharts

final class CryptoDetailViewModel: BaseViewModel {
  
  // MARK: - Enum
  
  enum CryptoDetailEventType {
    case loading(Bool)
    case graphUpdated(CryptoGraphEntity?)
    case showError(String)
  }
  
  enum SegmentType: String, CaseIterable {
    case oneHour = "1 Hour"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
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
    fetchOneHourGraphDetail()
  }
  
  func fetchDailyGraphDetail() {
    eventTrigger?(.loading(true))
    useCase.fetchDailyChanges(completion: { [weak self] result in
      self?.eventTrigger?(.loading(false))
      switch result {
      case .fetchGraphSuccess(let detail):
        self?.eventTrigger?(.graphUpdated(detail))
      case .fetchGraphFail(let errorMsg):
        self?.eventTrigger?(.showError(errorMsg ?? "Veri çekilirken hata meydana geldi"))
      }
    })
  }
  
  private func fetchOneHourGraphDetail() {
    eventTrigger?(.loading(true))
    useCase.fetchLast1HourChanges(completion: { [weak self] result in
      self?.eventTrigger?(.loading(false))
      switch result {
      case .fetchGraphSuccess(graphDetail: let detail):
        self?.eventTrigger?(.graphUpdated(detail))
      case .fetchGraphFail(error: let errorMsg):
        self?.eventTrigger?(.showError(errorMsg ?? "Veri çekilirken hata meydana geldi"))
      }
    })
  }
  
  private func fetchWeeklyGraphDetail() {
    eventTrigger?(.loading(true))
    useCase.fetchWeeklyChanges(completion: { [weak self] result in
      self?.eventTrigger?(.loading(false))
      switch result {
      case .fetchGraphSuccess(graphDetail: let detail):
        self?.eventTrigger?(.graphUpdated(detail))
      case .fetchGraphFail(error: let errorMsg):
        self?.eventTrigger?(.showError(errorMsg ?? "Veri çekilirken hata meydana geldi"))
      }
    })
  }
  
  private func fetchMonthlyGraphDetail() {
    eventTrigger?(.loading(true))
    useCase.fetchMonthlyChanges(completion: { [weak self] result in
      self?.eventTrigger?(.loading(false))
      switch result {
      case .fetchGraphSuccess(graphDetail: let detail):
        self?.eventTrigger?(.graphUpdated(detail))
      case .fetchGraphFail(error: let errorMsg):
        self?.eventTrigger?(.showError(errorMsg ?? "Veri çekilirken hata meydana geldi"))
      }
    })
  }
  
  func segmentChanged(item: SegmentType) {
    switch item {
    case .oneHour:
      fetchOneHourGraphDetail()
    case .daily:
      fetchDailyGraphDetail()
    case .weekly:
      fetchWeeklyGraphDetail()
    case .monthly:
      fetchMonthlyGraphDetail()
    }
  }
  
  func createDataEntries(xValues: [Double], yValues: [Double]) -> [ChartDataEntry] {
    return zip(xValues, yValues).map { x, y in
      ChartDataEntry(x: x, y: y)
    }
  }
  
  func createLineDataSet(entries: [ChartDataEntry]) -> LineChartDataSet {
    let lineDataSet = LineChartDataSet(entries: entries, label: "")
    lineDataSet.colors = [.graphBlue]
    lineDataSet.valueColors = [.clear]
    lineDataSet.drawCirclesEnabled = false
    lineDataSet.lineWidth = 2
    lineDataSet.drawHorizontalHighlightIndicatorEnabled = true
    return lineDataSet
  }
}

