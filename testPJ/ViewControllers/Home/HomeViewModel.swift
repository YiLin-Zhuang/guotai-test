//
//  HomeViewModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

class HomeViewModel {
    var endRefreshing: (() -> Void)?
    
    @Observed(queue: .main)
    var data:HomeModel? = nil
    
    @Observed(queue: .main)
    var loading:Bool = true
}
