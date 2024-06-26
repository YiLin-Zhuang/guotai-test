//
//  AccountModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

// MARK: - AccountModel
struct AccountModel: Codable {
    let account, curr: String
    let balance: Double
}
