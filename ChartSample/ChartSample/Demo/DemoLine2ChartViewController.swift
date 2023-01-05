#if canImport(UIKit)
	import UIKit
#endif
import Charts

class LineChart2ViewController: DemoBaseViewController {

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
		slider.maximumValue = 100
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
		chartView.dragEnabled = false
		chartView.setScaleEnabled(false)
		chartView.pinchZoomEnabled = false
		chartView.legend.enabled = false
		chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
		chartView.xAxis.gridLineWidth = 0
		chartView.rightAxis.enabled = false

		let xAxis = chartView.xAxis
		xAxis.labelFont = .systemFont(ofSize: 11)
		xAxis.labelTextColor = .white
		xAxis.drawAxisLineEnabled = false
		xAxis.axisMinimum = 2021
		xAxis.spaceMin = 1

		let leftAxis = chartView.leftAxis
		leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
		leftAxis.axisMaximum = 100
		leftAxis.axisMinimum = 0
		leftAxis.drawGridLinesEnabled = true

		sliderX.value = 20
		sliderY.value = 30

		chartView.animate(xAxisDuration: 2.5)
		updateChartData()
	}

	override func updateChartData() {
		if self.shouldHideData {
			chartView.data = nil
			return
		}

		self.setDataCount(Int(sliderX.value + 1), range: UInt32(sliderY.value))
	}

	func setDataCount(_ count: Int, range: UInt32) {
		let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
			let val = Double(arc4random_uniform(range))
			return ChartDataEntry(x: Double(i + 2021), y: val)
		}

		let set1 = LineChartDataSet(entries: yVals1)
		set1.axisDependency = .left
		set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
		set1.setCircleColor(.white)
		set1.lineWidth = 2
		set1.circleRadius = 3
		set1.fillAlpha = 65/255
		set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
		set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
		set1.drawCircleHoleEnabled = false

		let data: LineChartData = [set1]
		data.setValueTextColor(.white)
		data.setValueFont(.systemFont(ofSize: 9))

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
