//
//  ChartMarker.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 30.11.2024.
//

import UIKit
import DGCharts

class ChartMarker: MarkerView {
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(label)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Components
  
  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 12)
    label.textColor = .white
    label.backgroundColor = .graphBlue
    label.textAlignment = .center
    label.numberOfLines = 0
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    return label
  }()
  
  override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
    let priceString = String(format: "Price: %.2f", entry.y)
    
    let timestamp = Int(entry.x)
    let timeString = "Time: \(timestamp.formattedDateString())"
    
    label.text = "\(priceString)\n\(timeString)"
    label.sizeToFit()
    label.frame = CGRect(x: 0, y: 0, width: label.frame.width + 10, height: label.frame.height + 5)
  }
  
  override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
      guard let chartView = chartView else { return .zero }
      
      let chartWidth = chartView.frame.width
      let chartHeight = chartView.frame.height

      let markerWidth = label.frame.width
      let markerHeight = label.frame.height

      // Varsayılan offsetler
      var offsetX = -markerWidth / 2
      var offsetY = -markerHeight - 10

      // right-left edge control
      if point.x + offsetX + markerWidth > chartWidth {
          offsetX = -markerWidth - 10
      } else if point.x + offsetX < 0 {
          offsetX = 10
      }

      // top-bottom edge control
      if point.y + offsetY < 0 {
          offsetY = 10
      } else if point.y > chartHeight - markerHeight {
          offsetY = -markerHeight - 10
      }

      return CGPoint(x: offsetX, y: offsetY)
  }
}
