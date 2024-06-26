//
//  UIApplicationEX.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit

extension UIApplication {
    static func exitApp() {
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    public class func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
        
        let base = base == nil ? UIWindow.key?.rootViewController : base
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
