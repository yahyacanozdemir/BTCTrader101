//
//  CryptoDetailContentView.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit
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
  
  private lazy var segmentedControl: UISegmentedControl = {
    let items = CryptoDetailViewModel.SegmentType.allCases.map { $0.rawValue }
    let segmentedControl = UISegmentedControl(items: items)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.backgroundColor = .btcTurkDark.withAlphaComponent(0.4)
    segmentedControl.selectedSegmentTintColor = .graphBlue
    segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.graphBlue],for: .normal)
    segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.btcTurkWhite],for: .selected)
    segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    return segmentedControl
  }()
  
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
        self?.lineChartView.isHidden = isShow
        self?.contentLoadingView.isHidden = !isShow
      case .graphUpdated(let graph):
        self?.setupChartData(graph)
      case .showError(_):
        self?.lineChartView.data = nil
        self?.lineChartView.clear()
        self?.lineChartView.noDataText = "Veri alınamadı."
        break
      }
    }
  }
  // MARK: - Layout
  
  override func setupSubviews() {
    backgroundColor = .btcTurkDark
    addSubview(segmentedControl)
    addSubview(lineChartView)
    addSubview(contentLoadingView)
    
    setupChartView()
  }
  
  override func setupConstraints() {
    segmentedControl.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(36)
      make.horizontalEdges.equalToSuperview().inset(8)
      make.height.equalTo(40)
    }
    lineChartView.snp.makeConstraints { make in
      make.top.equalTo(segmentedControl.snp.bottom).offset(36)
      make.horizontalEdges.equalToSuperview().inset(8)
      make.height.equalTo(148)
    }
    contentLoadingView.snp.makeConstraints { make in
      make.edges.equalTo(lineChartView)
    }
  }
  
  @objc private func segmentChanged(_ sender: UISegmentedControl) {
    let segment = CryptoDetailViewModel.SegmentType.allCases[sender.selectedSegmentIndex]
    viewModel.segmentChanged(item: segment)
  }
  
  // MARK: - Chart Setup
  
  private func setupChartView() {
    lineChartView.backgroundColor = .btcTurkDarkBlue.withAlphaComponent(0.15)
    lineChartView.noDataTextColor = .btcTurkWhite
    lineChartView.legend.enabled = false
    lineChartView.leftAxis.enabled = false
    lineChartView.drawGridBackgroundEnabled = false
    
    setupChartAxes()
    
    let marker = ChartMarker(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    marker.chartView = lineChartView
    lineChartView.marker = marker
    
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
      lineChartView.noDataText = "Veri bulunamadı."
      return
    }
    
    let dataEntries = viewModel.createDataEntries(xValues: time, yValues: close)
    let lineDataSet = viewModel.createLineDataSet(entries: dataEntries)
    configureGradientForLineDataSet(lineDataSet)
    
    let lineChartData = LineChartData(dataSet: lineDataSet)
    lineChartView.data = lineChartData
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
