import UIKit
import Charts

class StackedBarChartView: UIView {
	private lazy var chartView: BarChartView = {
		let chartView: BarChartView = .init()
		chartView.chartDescription.enabled = false

		chartView.maxVisibleCount = 1
		chartView.drawBarShadowEnabled = false
		chartView.drawValueAboveBarEnabled = false

		// x, y축 제거
		chartView.rightAxis.enabled = false
		chartView.leftAxis.enabled = false
		chartView.xAxis.enabled = false

		// 차트 관련 추가기능 제거
		chartView.autoScaleMinMaxEnabled = false
		chartView.scaleXEnabled = false
		chartView.scaleYEnabled = false
		chartView.highlightFullBarEnabled = false
		// 차트 추가 정보 제거
		chartView.legend.enabled = false
		chartView.data = nil
		return chartView
	}()

	init() {
		super.init(frame: .zero)
		initView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setup(count: Int, range: Int) {
		// TODO: count는 1개로 고정, range는 상황에 따라
		self.setChartData(count: 1, range: 100)
	}

	private func initView() {
		addSubview(chartView)
		chartView.snp.makeConstraints({ (maker) in
			maker.edges.equalToSuperview()
		})
	}

	private func setChartData(count: Int, range: UInt32) {
		let xValues = (0..<count).map { (i) -> BarChartDataEntry in
			let mult = range + 1
			let val1 = Double(arc4random_uniform(mult) + mult / 3)
			let val2 = Double(arc4random_uniform(mult) + mult / 3)
			let val3 = Double(arc4random_uniform(mult) + mult / 3)

			return BarChartDataEntry(x: Double(i), yValues: [val1, val2, val3])
		}

		let set = BarChartDataSet(entries: xValues, label: "")
		set.drawIconsEnabled = false
		set.drawValuesEnabled = false
		set.highlightEnabled = false
		set.colors = [ChartColorTemplates.material()[0], ChartColorTemplates.material()[1], ChartColorTemplates.material()[2]]

		let data = BarChartData(dataSet: set)
		chartView.fitBars = true
		chartView.data = data
	}
}
