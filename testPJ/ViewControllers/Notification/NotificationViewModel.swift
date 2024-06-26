//
//  NotificationViewModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

public class NotificationViewModel {
    var messages: [NotificationModel.Message]
    
    init(messages: [NotificationModel.Message]) {
        self.messages = messages
    }
}
