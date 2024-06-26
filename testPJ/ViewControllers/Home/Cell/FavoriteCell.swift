//
//  FavoriteCell.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var iconImageView: UIImageView!
    
    func setup(_ viewModel: FavoriteCellViewModel) {
        self.titleLabel.text = viewModel.title
        self.iconImageView.image = viewModel.icon
        setNeedsLayout()
    }
}
