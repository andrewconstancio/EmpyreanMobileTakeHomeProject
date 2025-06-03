//
//  ItemDetailViewController+Ext.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//
import UIKit

// MARK: - ItemDetailViewController Collection View Extensions

extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            return itemComments.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailHeaderCell.identifier, for: indexPath) as! DetailHeaderCell
            cell.delegate = self
            cell.itemAndUser = itemAndUser
            loadAvatarImage(for: cell, item: itemAndUser)
            loadDetailsImage(for: cell, item: itemAndUser)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCommentLabel.identifier, for: indexPath) as! DetailCommentLabel
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCommentCell.identifier, for: indexPath) as! DetailCommentCell
            cell.set(comment: itemComments[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .systemIndigo
            return cell
        }
    }
}

// MARK: - ItemDetailViewController Collection View Helper Functions

extension ItemDetailViewController {
    
    /// Load the avatar image for the user on the item
    func loadAvatarImage(for cell: DetailHeaderCell, item: ItemAndUser) {
        networkImage.downloadImage(from: item.user.avatar) { [weak cell] image in
            DispatchQueue.main.async {
                cell?.avatarButton.setImage(image, for: .normal)
            }
        }
    }
    
    /// Load the details image for the post
    func loadDetailsImage(for cell: DetailHeaderCell, item: ItemAndUser) {
        networkImage.downloadImage(from: item.item.image) { [weak cell] image in
            DispatchQueue.main.async {
                cell?.itemImage.image = image
            }
        }
    }
}

// MARK: - ItemDetailViewController DetailHeaderCellDelagate Delegate

extension ItemDetailViewController: DetailHeaderCellDelagate {
    /// Tapping on the avatar image to display information on the user 
    func didTapAvatarButton(user: User) {
        let userDetailVC = UserDetailViewController(
            user: user,
            apiClient: APIClient(urlString: EMConstants.baseURL, urlSession: URLSession.shared),
            networkImage: NetworkImage(urlSession: URLSession.shared)
        )
        self.present(userDetailVC, animated: true)
    }
}



