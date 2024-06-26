//
//  DigitalModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

// MARK: - DigitalModel
struct DigitalModel: baseResponse {
    var msgCode: String
    var msgContent: String
    let result: Result
    
    // MARK: - Result
    struct Result: Codable {
        @DecodableDefault.EmptyList var digitalList: [AccountModel]
    }
}
