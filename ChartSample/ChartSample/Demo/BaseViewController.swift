//
//  DemoBaseViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-03.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
	import UIKit
#endif
import Charts
import SnapKit

class DemoBaseViewController: UIViewController, ChartViewDelegate {
	private var optionsTableView: UITableView? = nil
	let optionsButton: UIButton = {
		let button: UIButton = .init()
		button.setTitle("options", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .light)
		return button
	}()

	var shouldHideData: Bool = false

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.initialize()
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.initialize()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(optionsButton)
		optionsButton.snp.makeConstraints({ (maker) in
			maker.trailing.equalToSuperview().offset(-16)
			maker.top.equalTo(view.safeAreaLayoutGuide)
		})
	}

	private func initialize() {
		self.edgesForExtendedLayout = []
	}


	func updateChartData() {
		fatalError("updateChartData not overridden")
	}
}

