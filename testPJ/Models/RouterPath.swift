//
//  RouterPath.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit

public enum RouterPath: RouterPathable {
    case notificationPage(NotificationViewModel)
  
    public var any: AnyClass {
    switch self {
    case .notificationPage:
      return NotificationViewController.self
    }
  }
  
    public var params: RouterParameter? {
    switch self {
    case .notificationPage(let viewModel):
        return ["viewModel":viewModel]
    }
  }
}
