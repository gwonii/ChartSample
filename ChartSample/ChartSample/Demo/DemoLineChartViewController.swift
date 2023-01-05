//
//  LineChart1ViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import UIKit
import Charts

class DemoLineChartViewController: DemoBaseViewController {

	private let chartView: LineChartView = {
		let chartView: LineChartView = .init()
		return chartView
	}()
	private let sliderTextX: UILabel = {
		let label: UILabel = .init()
		label.font = .systemFont(ofSize: 16, weight: .light)
		label.textColor = .white
		label.text = "12"
		return label
	}()
	private let sliderTextY: UILabel = {
		let label: UILabel = .init()
		label.font = .systemFont(ofSize: 16, weight: .light)
		label.textColor = .white
		label.text = "100"
		return label
	}()
	private lazy var sliderX: UISlider = {
		let slider: UISlider = .init()
		slider.minimumValue = 0
		slider.maximumValue = 12
		slider.addTarget(self, action: #selector(self.onChangeValueSliderX(sender:)), for: .valueChanged)
		return slider
	}()
	private lazy var sliderY: UISlider = {
		let slider: UISlider = .init()
		slider.minimumValue = 0
		slider.maximumValue = 500
		slider.addTarget(self, action: #selector(self.onChangeValueSliderY(sender:)), for: .valueChanged)
		return slider
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(chartView)
		view.addSubview(sliderTextX)
		view.addSubview(sliderTextY)
		view.addSubview(sliderX)
		view.addSubview(sliderY)
		chartView.snp.makeConstraints({ (maker) in
			maker.height.equalTo(600)
			maker.top.equalTo(optionsButton.snp.bottom).offset(16)
			maker.leading.equalToSuperview().offset(16)
			maker.trailing.equalToSuperview().offset(-16)
		})
		sliderTextX.snp.makeConstraints({ (maker) in
			maker.leading.equalToSuperview().offset(16)
			maker.top.equalTo(chartView.snp.bottom).offset(12)
		})
		sliderX.snp.makeConstraints({ (maker) in
			maker.height.equalTo(40)
			maker.width.equalTo(240)
			maker.trailing.equalToSuperview().offset(-16)
			maker.centerY.equalTo(sliderTextX)
		})
		sliderTextY.snp.makeConstraints({ (maker) in
			maker.leading.equalToSuperview().offset(16)
			maker.top.equalTo(sliderX.snp.bottom).offset(8)
		})
		sliderY.snp.makeConstraints({ (maker) in
			maker.height.equalTo(40)
			maker.width.equalTo(240)
			maker.trailing.equalToSuperview().offset(-16)
			maker.centerY.equalTo(sliderTextY.snp.centerY)
		})

		chartView.chartDescription.enabled = false
		chartView.dragEnabled = true
		chartView.setScaleEnabled(true)
		chartView.pinchZoomEnabled = true

		chartView.xAxis.gridLineWidth = 0
		chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom

		let leftAxis = chartView.leftAxis
		leftAxis.removeAllLimitLines()
		leftAxis.axisMaximum = 200
		leftAxis.axisMinimum = -50
		leftAxis.gridLineDashLengths = [5, 5]
		leftAxis.drawGridLinesEnabled = true
		leftAxis.granularityEnabled = true

		chartView.rightAxis.enabled = false

		sliderX.value = 45
		sliderY.value = 100

		chartView.animate(xAxisDuration: 2.5)
		updateChartData()
	}

	override func updateChartData() {
		if self.shouldHideData {
			chartView.data = nil
			return
		}

		self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
	}

	func setDataCount(_ count: Int, range: UInt32) {
		let values = (0..<count).map { (i) -> ChartDataEntry in
			let val = Double(arc4random_uniform(range) + 3)
			return ChartDataEntry(x: Double(i), y: val)
		}

		let set1 = LineChartDataSet(entries: values, label: "")
		set1.axisDependency = .left
		set1.setColor(.red)
		set1.setCircleColor(.white)
		set1.lineWidth = 2
		set1.circleRadius = 3
		set1.fillAlpha = 65/255
		set1.fillColor = .red
		set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
		set1.drawCircleHoleEnabled = false

		setup(set1)

//		let value = ChartDataEntry(x: Double(3), y: 3)
//		_ = set1.addEntryOrdered(value)
		let data = LineChartData(dataSet: set1)
		data.setValueTextColor(.white)
		data.setValueFont(.systemFont(ofSize: 9))
		chartView.data = data
	}

	private func setup(_ dataSet: LineChartDataSet) {
		if dataSet.isDrawLineWithGradientEnabled {
			dataSet.lineDashLengths = nil
			dataSet.highlightLineDashLengths = nil
			dataSet.setColors(.black, .red, .white)
			dataSet.setCircleColor(.black)
			dataSet.gradientPositions = [0, 40, 100]
			dataSet.lineWidth = 1
			dataSet.circleRadius = 3
			dataSet.drawCircleHoleEnabled = false
			dataSet.valueFont = .systemFont(ofSize: 9)
			dataSet.formLineDashLengths = nil
			dataSet.formLineWidth = 1
			dataSet.formSize = 15
		} else {
			dataSet.lineDashLengths = [5, 2.5]
			dataSet.highlightLineDashLengths = [5, 2.5]
			dataSet.setColor(.black)
			dataSet.setCircleColor(.black)
			dataSet.gradientPositions = nil
			dataSet.lineWidth = 1
			dataSet.circleRadius = 3
			dataSet.drawCircleHoleEnabled = false
			dataSet.valueFont = .systemFont(ofSize: 9)
			dataSet.formLineDashLengths = [5, 2.5]
			dataSet.formLineWidth = 1
			dataSet.formSize = 15
		}
	}

	override func optionTapped(_ option: Option) {
		guard let data = chartView.data else { return }

		switch option {
		case .toggleFilled:
			for case let set as LineChartDataSet in data {
				set.drawFilledEnabled = !set.drawFilledEnabled
			}
			chartView.setNeedsDisplay()

		case .toggleCircles:
			for case let set as LineChartDataSet in data {
				set.drawCirclesEnabled = !set.drawCirclesEnabled
			}
			chartView.setNeedsDisplay()

		case .toggleCubic:
			for case let set as LineChartDataSet in data {
				set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
			}
			chartView.setNeedsDisplay()

		case .toggleStepped:
			for case let set as LineChartDataSet in data {
				set.mode = (set.mode == .stepped) ? .linear : .stepped
			}
			chartView.setNeedsDisplay()

		case .toggleHorizontalCubic:
			for case let set as LineChartDataSet in data {
				set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
			}
			chartView.setNeedsDisplay()
		case .toggleGradientLine:
			for set in chartView.data!.dataSets as! [LineChartDataSet] {
				set.isDrawLineWithGradientEnabled = !set.isDrawLineWithGradientEnabled
				setup(set)
			}
			chartView.setNeedsDisplay()
		default:
			super.handleOption(option, forChartView: chartView)
		}
	}

	@objc
	private func onChangeValueSliderX(sender: UISlider) {
		sliderTextX.text = "\(Int(sender.value))"
		updateChartData()
	}

	@objc
	private func onChangeValueSliderY(sender: UISlider) {
		sliderTextY.text = "\(Int(sender.value))"
		updateChartData()
	}
}
