//
//  DetailsView.swift
//  ListMate
//
//  Created by Sabir Alizade on 27.12.23.
//

import UIKit

protocol DetailsViewDelegate: AnyObject {
    func updateDetailsData(measeure: Measures, price: Double, store: String)
}

class DetailsView: BaseView {
    
    weak var delegate: DetailsViewDelegate?
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            selectedSegmentIndex(item: item)
            pricetextField.text = "\(item.price)"
            storeTextField.text = item.boughtAt
        }
    }
    
    private let detailsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private let measureLabel = CustomLabel(text: "Measure:", textColor: .black, font: .poppinsFont(size: 16, weight: .light), alignment: .left)
    
    private lazy var measuresSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.addTarget(self, action: #selector (didTapValueChanged), for: .valueChanged)
        return control
    }()
    
    private let priceLabel = CustomLabel(text: "Price per package:", textColor: .black, font: .poppinsFont(size: 16, weight: .light), alignment: .left)
    
    private lazy var pricetextField = CustomTextField(placeHolder: "Enter price",
                                                      keybord: .numberPad,
                                                      target: self,
                                                      action: #selector(didTapValueChanged))
    
    private let storeLabel = CustomLabel(text: "Store:", textColor: .black, font: .poppinsFont(size: 16, weight: .light), alignment: .left)
    
    private lazy var storeTextField = CustomTextField(placeHolder: "Enter store name",
                                                      target: self,
                                                      action: #selector(didTapValueChanged))
    
    override func setupView() {
        super.setupView()
        setupUI()
        setupSegmentedControl()
    }
    
    private func setupUI() {
        
        let measureStack = UIView().HStack(views: measureLabel, measuresSegmentControl.withWidth(240), spacing: 10, distribution: .fill)
        
        let priceStack = UIView().HStack(views: priceLabel, pricetextField, spacing: 10, distribution: .fill)
        
        let storeStack = UIView().HStack(views: storeLabel, storeTextField, spacing: 10, distribution: .fill)
        
        let vStack = UIView().VStack(views: measureStack, priceStack, storeStack, spacing: 20, distribution: .fill)
        
        self.anchorFill(view: detailsView)
        
        detailsView.anchor(view: vStack) { kit in
            kit.leading(10)
            kit.trailing(10)
            kit.top(20)
            kit.bottom(20)
        }
    }
    
    @objc
    private func didTapValueChanged() {
        guard let price = Double(pricetextField.text ?? "") else { return }
        guard let store = storeTextField.text else { return }
        let selectedMeasure = Measures.allCases[measuresSegmentControl.selectedSegmentIndex]
        
        delegate?.updateDetailsData(measeure: selectedMeasure, price: price, store: store)
    }
    
    private func selectedSegmentIndex(item: ItemModel) {
        guard let selectedIndex = Measures.allCases.firstIndex(of: item.measure) else {
            return
        }
        measuresSegmentControl.selectedSegmentIndex = selectedIndex
    }
    
    private func setupSegmentedControl() {
        for (index, measure) in Measures.allCases.enumerated() {
            measuresSegmentControl.insertSegment(withTitle: measure.rawValue, at: index, animated: true)
        }
    }
}
