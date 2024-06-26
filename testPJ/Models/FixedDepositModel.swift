//
//  FixedDepositModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

// MARK: - FixedDepositModel
struct FixedDepositModel: baseResponse {
    var msgCode: String
    var msgContent: String
    let result: Result
    
    // MARK: - Result
    struct Result: Codable {
        @DecodableDefault.EmptyList var fixedDepositList: [AccountModel]
    }
}
