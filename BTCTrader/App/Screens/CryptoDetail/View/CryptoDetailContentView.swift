//
//  CryptoDetailContentView.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit
import Charts
import DGCharts

class CryptoDetailContentView: BaseView {
  
  // MARK: - Initialization
  
  init(viewModel: CryptoDetailViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  
  private let viewModel: CryptoDetailViewModel
  
  // MARK: - UI Components
  private lazy var lineChartView = LineChartView()
  private lazy var contentLoadingView: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .btcTurkWhite
    indicator.startAnimating()
    return indicator
  }()
  
  // MARK: - Lifecycle
  
  func inject() {
    viewModel.start()
    bind()
  }
  
  override func bind() {
    viewModel.eventTrigger = { [weak self] type in
      switch type {
      case .loading(let isShow):
        self?.contentLoadingView.isHidden = !isShow
      case .graphUpdated(let graph):
        self?.setupChartData(graph)
      case .showError(_):
        self?.lineChartView.data = nil
        self?.lineChartView.noDataText = "Veri alınamadı."
        break
      }
    }
  }
  // MARK: - Setup Subviews
  
  override func setupSubviews() {
    backgroundColor = .btcTurkDark
    addSubview(lineChartView)
    addSubview(contentLoadingView)
    
    setupChartView()
  }
  
  // MARK: - Setup Constraints
  
  override func setupConstraints() {
    lineChartView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(36)
      make.horizontalEdges.equalToSuperview().inset(8)
      make.height.equalTo(148)
    }
    contentLoadingView.snp.makeConstraints { make in
      make.edges.equalTo(lineChartView)
    }
  }
  
  // MARK: - Chart Setup
  
  private func setupChartView() {
    lineChartView.backgroundColor = .btcTurkDarkBlue.withAlphaComponent(0.15)
    lineChartView.noDataText = "Veri bulunamadı."
    lineChartView.legend.enabled = false
    lineChartView.leftAxis.enabled = false
    lineChartView.drawGridBackgroundEnabled = false
    
    setupChartAxes()
    lineChartView.animate(xAxisDuration: 1.5)
  }
  
  private func setupChartAxes() {
    let rightAxis = lineChartView.rightAxis
    rightAxis.labelTextColor = .white
    rightAxis.gridColor = .clear
    rightAxis.axisLineColor = .clear
    
    let xAxis = lineChartView.xAxis
    xAxis.labelTextColor = .white
    xAxis.gridColor = .clear
    xAxis.drawAxisLineEnabled = false
    xAxis.drawLabelsEnabled = false
  }
  
  // MARK: - Chart Data Setup
  
  private func setupChartData(_ graphDetail: CryptoGraphEntity?) {
    guard let close = graphDetail?.c, !close.isEmpty, let time = graphDetail?.t, !time.isEmpty else {
      print("Veri bulunamadı!")
      return
    }
    
    let dataEntries = createDataEntries(xValues: time, yValues: close)
    let lineDataSet = createLineDataSet(entries: dataEntries)
    
    let lineChartData = LineChartData(dataSet: lineDataSet)
    lineChartView.data = lineChartData
  }
  
  private func createDataEntries(xValues: [Double], yValues: [Double]) -> [ChartDataEntry] {
    return zip(xValues, yValues).map { x, y in
      ChartDataEntry(x: x, y: y)
    }
  }
  
  private func createLineDataSet(entries: [ChartDataEntry]) -> LineChartDataSet {
    let lineDataSet = LineChartDataSet(entries: entries, label: "")
    lineDataSet.colors = [.graphBlue]
    lineDataSet.valueColors = [.clear]
    lineDataSet.drawCirclesEnabled = false
    lineDataSet.lineWidth = 2
    lineDataSet.drawHorizontalHighlightIndicatorEnabled = true
    
    configureGradientForLineDataSet(lineDataSet)
    
    return lineDataSet
  }
  
  private func configureGradientForLineDataSet(_ lineDataSet: LineChartDataSet) {
    let gradientColors = [
      UIColor.graphBlue.cgColor,
      UIColor.clear.cgColor
    ]
    let colorLocations: [CGFloat] = [1.0, 0.0]
    let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: colorLocations)
    
    lineDataSet.drawFilledEnabled = true
    lineDataSet.fillColor = .graphBlue
    lineDataSet.fillAlpha = 0.5
    lineDataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
  }
}
