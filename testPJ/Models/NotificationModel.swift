//
//  NotificationModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: baseResponse {
    var msgCode: String
    var msgContent: String
    let result: Result
    
    // MARK: - Result
    struct Result: Codable {
        @DecodableDefault.EmptyList var messages: [Message]
    }

    // MARK: - Message
    struct Message: Codable {
        let status: Bool
        let updateDateTime: String
        let title: String
        let message: String
    }
}


