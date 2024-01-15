//
//  SuggestionsToolbarView.swift
//  ListMate
//
//  Created by Sabir Alizade on 29.12.23.
//

import UIKit


class SuggestionsToolbarView: BaseView {
    
    var viewModel: NewItemViewModel = {
        let model = NewItemViewModel(session: .shared)
        return model
    }()
    
    private lazy var collectionView: UICollectionView = {
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
    
    override func setupView() {
        super.setupView()
        viewModel.readData()
        setupUI()
    }
    
    private func setupUI() {
        self.anchorFill(view: collectionView)
    }
}

extension SuggestionsToolbarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.catalogItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.catalogItems[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCell.description(), for: indexPath) as? SuggestionCell else { return UICollectionViewCell() }
        cell.item = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem  = viewModel.catalogItems[indexPath.item]
        
        viewModel.passSuggestedItem(name: selectedItem.name, price: selectedItem.price, measure: selectedItem.measure)
        viewModel.catalogItems.remove(at: indexPath.item)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
}
