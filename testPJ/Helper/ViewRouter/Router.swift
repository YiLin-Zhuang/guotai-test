//
//  Router.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation
import UIKit

public typealias RouterParameter = [String: Any]
public protocol Routable {
    /**
     类的初始化方法
     - params 传参字典
     */
    static func initWithParams(params: RouterParameter?) -> UIViewController
}

public protocol RouterPathable {
    var any: AnyClass { get }
    var params: RouterParameter? { get }
}

public class Router {
    open class func open(_ path:RouterPath , present: Bool = true , animated: Bool = true , presentComplete: (()->Void)? = nil){
        if let cls = path.any as? Routable.Type {
            let vc = cls.initWithParams(params: path.params)
            vc.hidesBottomBarWhenPushed = true
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            
            let topVC = UIApplication.topViewController()
            if topVC == nil {
                print("Error: You don't have any views set.")
            }
            let topViewController = topVC
            if topViewController?.navigationController != nil && !present {
                topViewController?.navigationController?.pushViewController(vc, animated: animated)
            }else{
                topViewController?.present(vc, animated: animated , completion: presentComplete)
            }
        }
    }
}
