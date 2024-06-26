//
//  StoryboardBased.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit

public protocol StoryboardBased: AnyObject {
    /// The UIStoryboard to use when we want to instantiate this ViewController
    static var sceneStoryboard: UIStoryboard { get }
    
    static var sceneIdentifier: String { get }
}

// MARK: Default Implementation
public extension StoryboardBased {
    /// By default, use the storybaord with the same name as the class
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
    }
    
    static var sceneIdentifier: String {
        return String(describing: self)
    }
}

// MARK: Support for instantiation from Storyboard
public extension StoryboardBased where Self: UIViewController {
    /**
     Create an instance of the ViewController from its associated Storyboard's initialViewController
     - returns: instance of the conforming ViewController
     */
    static func instantiate(_ storyboardName:String? = nil) -> Self {
        if let storyboardName = storyboardName {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: self.sceneIdentifier)
            guard let typedViewController = viewController as? Self else {
                fatalError("The viewController '\(self.sceneIdentifier)' of '\(storyboard)' is not of class '\(self)'")
            }
            return typedViewController
        } else {
            let viewController = sceneStoryboard.instantiateInitialViewController()
            guard let typedViewController = viewController as? Self else {
                fatalError("The initialViewController of '\(sceneStoryboard)' is not of class '\(self)'")
            }
            return typedViewController
        }
        
    }
}
