//
//  HomeViewController+Ext.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//

import UIKit

// MARK: - HomeViewController Collection View Extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedFetchError != nil ? 1 : itemAndUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let _ = feedFetchError {
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedErrorCell.identifier,
                for: indexPath
            ) as! FeedErrorCell
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCell.identifier,
            for: indexPath
        ) as! FeedCell
        
        let item = itemAndUser[indexPath.item]
        cell.item = item
        cell.delegate = self
        loadAvatarImage(for: cell, item: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let _ = feedFetchError {
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
        
        return CGSize(width: view.frame.width - 16, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemAndUser[indexPath.item]
        let detailVC = ItemDetailViewController(
            itemAndUser: item,
            apiClient: APIClient(urlString: EMConstants.baseURL, urlSession: URLSession.shared),
            networkImage: NetworkImage(urlSession: URLSession.shared)
        )
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - HomeViewController Collection View Helper Functions

extension HomeViewController {
    func loadAvatarImage(for cell: FeedCell, item: ItemAndUser) {
        networkImage.downloadImage(from: item.user.avatar) { [weak cell] image in
            DispatchQueue.main.async {
                cell?.avatarButton.setImage(image, for: .normal)
            }
        }
    }
}

// MARK: - FeedCellCellDelagate DetailHeaderCellDelagate Delegate

extension HomeViewController: FeedCellCellDelagate {
    func didTapAvatarButton(user: User) {
        let userDetailVC = UserDetailViewController(
            user: user,
            apiClient: APIClient(urlString: EMConstants.baseURL, urlSession: URLSession.shared),
            networkImage: NetworkImage(urlSession: URLSession.shared)
        )
        self.present(userDetailVC, animated: true)
    }
    
    func presentAlertMessage(title: String, message: String, buttonTitle: String) {
        self.presentAlertOnMainThread(title: title, message: message, buttonTitle: buttonTitle)
    }
}
