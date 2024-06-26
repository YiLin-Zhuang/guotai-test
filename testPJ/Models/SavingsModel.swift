//
//  SavingsModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

// MARK: - SavingsListModel
struct SavingsModel: baseResponse {
    var msgCode: String
    var msgContent: String
    let result: Result
    
    // MARK: - Result
    struct Result: Codable {
        @DecodableDefault.EmptyList var savingsList: [AccountModel]
    }
}
