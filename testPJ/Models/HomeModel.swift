//
//  HomeModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation
import UIKit

struct HomeModel {
    var usdSum: Double
    var khrSum: Double
    var notification: NotificationViewModel?
    var favorite: [FavoriteCellViewModel]
    var adBanner: [UIImage]
}
