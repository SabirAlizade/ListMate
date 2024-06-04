//
//  DetailsView.swift
//  ListMate
//
//  Created by Sabir Alizade on 27.12.23.
//

import UIKit
import RealmSwift

protocol DetailsViewDelegate: AnyObject {
    func updateDetailsData(measeure: Measures, price: Decimal128, store: String)
}

class DetailsView: BaseView {
    
    weak var delegate: DetailsViewDelegate?
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            selectedSegmentIndex(item: item.measure)
            priceTextField.text = Double.doubleToString(double: item.price.doubleValue)
            storeTextField.text = item.storeName
            adjustPriceTextFieldWidth()
        }
    }
    
    private let detailsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .mainwhite
        return view
    }()
    
    private let measureLabel = CustomLabel(
        text: LanguageBase.detailed(.measureLabel).translate,
        font: .poppinsFont(size: 16, weight: .light)
    )
    
    private let priceLabel = CustomLabel(
        text: LanguageBase.detailed(.priceLabel).translate,
        font: .poppinsFont(size: 16, weight: .light)
    )
    
    private lazy var priceTextField = PriceTextField(
        placeHolder: "0.00",
        target: self,
        action: #selector(didUpdateDetails)
    )
    
    private let storeLabel = CustomLabel(
        text: LanguageBase.detailed(.storeLabel).translate,
        font: .poppinsFont(size: 16, weight: .light)
    )
    
    private lazy var storeTextField = CustomTextField(
        placeHolder: LanguageBase.detailed(.storePlaceHolder).translate,
        target: self,
        action: #selector(didUpdateDetails)
    )
    
    private lazy var measuresSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.addTarget(self, action: #selector (didUpdateDetails), for: .valueChanged)
        return control
    }()
    
    override func setupView() {
        super.setupView()
        setupUI()
        setupSegmentedControl()
        priceTextField.addTarget(self, action: #selector(priceTextFieldDidChange), for: .editingChanged)
    }
    
    private func setupUI() {
        let measureStack = UIView().HStack(
            views: measureLabel,
            measuresSegmentControl.withWidth(240),
            spacing: 10,
            distribution: .fill
        )
        
        let priceStack = UIView().HStack(
            views: priceLabel,
            priceTextField,
            spacing: 10,
            distribution: .fill
        )
        
        let storeStack = UIView().HStack(
            views: storeLabel,
            storeTextField.withWidth(160),
            spacing: 10,
            distribution: .fill
        )
        
        let vStack = UIView().VStack(
            views: measureStack,
            priceStack,
            storeStack,
            spacing: 20,
            distribution: .fill
        )
        
        self.anchorFill(view: detailsView)
        
        detailsView.anchor(view: vStack) { kit in
            kit.leading(10)
            kit.trailing(10)
            kit.top(20)
            kit.bottom(20)
        }
    }
    
    @objc
    private func priceTextFieldDidChange() {
        adjustPriceTextFieldWidth()
    }
    
    
    private func adjustPriceTextFieldWidth() {
        priceTextField.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc
    private func didUpdateDetails() {
        guard let price = Decimal128.fromStringToDecimal(string: priceTextField.text ?? "") else { return }
        guard let store = storeTextField.text else { return }
        let selectedMeasure = Measures.allCases[measuresSegmentControl.selectedSegmentIndex]
        delegate?.updateDetailsData(measeure: selectedMeasure, price: price, store: store)
    }
    
    private func selectedSegmentIndex(item: Measures) {
        guard let selectedIndex = Measures.allCases.firstIndex(of: item) else { return }
        measuresSegmentControl.selectedSegmentIndex = selectedIndex
    }
    
    private func setupSegmentedControl() {
        for (index, measure) in Measures.allCases.enumerated() {
            let translatedTitle = measure.translate
            measuresSegmentControl.insertSegment(withTitle: translatedTitle, at: index, animated: true)
        }
    }
}
