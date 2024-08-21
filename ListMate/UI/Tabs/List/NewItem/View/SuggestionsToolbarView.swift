//
//  SuggestionsToolbarView.swift
//  ListMate
//
//  Created by Sabir Alizade on 29.12.23.
//

import UIKit

class SuggestionsToolbarView: BaseView {
    
    var viewModel: NewItemViewModel
    
    init(viewModel: NewItemViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        loadCatalogData()
        setupUI()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .lightGray
        view.showsHorizontalScrollIndicator = false
        view.register(SuggestionCell.self, forCellWithReuseIdentifier: SuggestionCell.description())
        return view
    }()
    
    private func loadCatalogData() {
        viewModel.readCatalogData()
    }
    
    private func setupUI() {
        self.anchorFill(view: collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SuggestionsToolbarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.catalogItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SuggestionCell.description(),
            for: indexPath
        ) as? SuggestionCell else { return UICollectionViewCell() }
        
        let item = viewModel.catalogItems[indexPath.item]
        cell.item = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 133, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = viewModel.catalogItems[indexPath.item]
        
        viewModel.passSuggestedItem(name: selectedItem.name, price: selectedItem.price, measure: selectedItem.measure)
        
        collectionView.performBatchUpdates({
            viewModel.catalogItems.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
        viewModel.checkCatalogCount()
    }
}
