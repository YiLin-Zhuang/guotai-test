//
//  EmptyFavoriteView.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit

class EmptyFavoriteView: UIView, NibFileOwnerLoadable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
