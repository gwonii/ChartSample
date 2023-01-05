//
//  StackedBarChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import UIKit
import Charts

class StackedBarChartViewController: DemoBaseViewController {
	private let chartView: BarChartView = {
		let chartView: BarChartView = .init()
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
		slider.addTarget(self, action: #selector(onChangeValueSliderX(sender:)), for: .valueChanged)
		return slider
	}()
	private lazy var sliderY: UISlider = {
		let slider: UISlider = .init()
		slider.minimumValue = 0
		slider.maximumValue = 500
		slider.addTarget(self, action: #selector(onChangeValueSliderY(sender:)), for: .valueChanged)
		return slider
	}()

	lazy var formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 1
		formatter.negativeSuffix = " $"
		formatter.positiveSuffix = " $"

		return formatter
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

		// Do any additional setup after loading the view.
		self.title = "Stacked Bar Chart"
		self.options = [.toggleValues,
						.toggleIcons,
						.toggleHighlight,
						.animateX,
						.animateY,
						.animateXY,
						.saveToGallery,
						.togglePinchZoom,
						.toggleAutoScaleMinMax,
						.toggleData,
						.toggleBarBorders]


		chartView.delegate = self

		chartView.chartDescription.enabled = false

		chartView.maxVisibleCount = 40
		chartView.drawBarShadowEnabled = false
		chartView.drawValueAboveBarEnabled = false
		chartView.highlightFullBarEnabled = false

		// x축, y축 제거
		chartView.rightAxis.enabled = false
		chartView.leftAxis.enabled = false
		chartView.xAxis.enabled = false
		chartView.autoScaleMinMaxEnabled = false
		chartView.scaleXEnabled = false
		chartView.scaleYEnabled = false
		chartView.legend.enabled = false
		

		sliderX.value = 12
		sliderY.value = 100

		self.updateChartData()
	}

	override func updateChartData() {
		if self.shouldHideData {
			chartView.data = nil
			return
		}

		self.setChartData(count: Int(sliderX.value + 1), range: UInt32(sliderY.value))
	}

	func setChartData(count: Int, range: UInt32) {
		let yVals = (0..<count).map { (i) -> BarChartDataEntry in
			let mult = range + 1
			let val1 = Double(arc4random_uniform(mult) + mult / 3)
			let val2 = Double(arc4random_uniform(mult) + mult / 3)
			let val3 = Double(arc4random_uniform(mult) + mult / 3)

			return BarChartDataEntry(x: Double(i), yValues: [val1, val2, val3])
		}

		let set = BarChartDataSet(entries: yVals, label: "")
		set.drawIconsEnabled = false
		set.drawValuesEnabled = false
		// color와 label
		set.colors = [ChartColorTemplates.material()[0], ChartColorTemplates.material()[1], ChartColorTemplates.material()[2]]
		set.stackLabels = ["Births", "Divorces", "Marriages"]

		// 개별 항목들 클릭하여 highlight 기능
		set.highlightEnabled = false

		let data = BarChartData(dataSet: set)

		data.setValueFont(.systemFont(ofSize: 0, weight: .light))
		data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
		data.setValueTextColor(.clear)

//		chartView.fitBars = true
		chartView.data = data
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
