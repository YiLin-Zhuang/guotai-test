//
//  UITableViewCellEX.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit

extension UITableViewCell {
    ///取得Identifier string
    static var identifier: String {
        return String(describing: self)
    }
    ///nib
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
