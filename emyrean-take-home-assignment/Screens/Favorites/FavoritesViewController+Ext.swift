//
//  FavoritesViewController+Ext.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/2/25.
//

import UIKit

// MARK: - FavoritesViewController Table View Extensions

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.delegate = self
        cell.item = favorite
        loadAvatarImage(for: cell, favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.item]
        let detailVC = ItemDetailViewController(
            itemAndUser: favorite,
            apiClient: APIClient(urlString: EMConstants.baseURL, urlSession: URLSession.shared),
            networkImage: NetworkImage(urlSession: URLSession.shared)
        )
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistanceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "OK")
        }
    }
}

// MARK: - FavoritesViewController Table View Helper Functions

extension FavoritesViewController {
    func loadAvatarImage(for cell: FavoriteCell, favorite: ItemAndUser) {
        networkImage.downloadImage(from: favorite.user.avatar) { [weak cell] image in
            DispatchQueue.main.async {
                cell?.avatarButton.setImage(image, for: .normal)
            }
        }
    }
}

extension FavoritesViewController: FavoriteCellDelegate {
    func didTapAvatarButton(user: User) {
        let userDetailVC = UserDetailViewController(
            user: user,
            apiClient: APIClient(urlString: EMConstants.baseURL, urlSession: URLSession.shared),
            networkImage: NetworkImage(urlSession: URLSession.shared)
        )
        self.present(userDetailVC, animated: true)
    }
}
