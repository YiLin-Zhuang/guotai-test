//
//  FavoriteModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

// MARK: - FavoriteModel
struct FavoriteModel: baseResponse {
    var msgCode: String
    var msgContent: String
    let result: Result
    
    // MARK: - Result
    struct Result: Codable {
        @DecodableDefault.EmptyList var favoriteList: [FavoriteList]
    }

    // MARK: - FavoriteList
    struct FavoriteList: Codable {
        let nickname, transType: String
    }
}


