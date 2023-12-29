//
//  SuggestionsToolbar.swift
//  ListMate
//
//  Created by Sabir Alizade on 29.12.23.
//

import UIKit


class SuggestionsToolbar: BaseView {
    
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
        view.backgroundColor = .maingray
        view.showsHorizontalScrollIndicator = false
        view.register(SuggestionCell.self, forCellWithReuseIdentifier: SuggestionCell.description())
        return view
    }()
    
    override func setupView() {
        super.setupView()
        viewModel.readData()
        setupUI()
        registerForKeyboardNorifications()
    }
    
    private func setupUI() {
        self.anchorFill(view: collectionView)
    }
    
    deinit {
        unregisterFromKeyboardNotifications()
    }
}

extension SuggestionsToolbar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.catalogItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.catalogItems[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCell.description(), for: indexPath) as? SuggestionCell else { return UICollectionViewCell() }
        cell.item = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem  = viewModel.catalogItems[indexPath.item]
        viewModel.passSuggestedItem(name: selectedItem.name , price: selectedItem.price )
        viewModel.catalogItems.remove(at: indexPath.item)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
}

extension SuggestionsToolbar {
    private func registerForKeyboardNorifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let toolbarHeight: CGFloat = 50
            let newFrame = CGRect(x: 0, y: keyboardFrame.origin.y - toolbarHeight, width: UIScreen.main.bounds.width, height: toolbarHeight)
            self.frame = newFrame
            self.isHidden = false
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.isHidden = true
    }
}
