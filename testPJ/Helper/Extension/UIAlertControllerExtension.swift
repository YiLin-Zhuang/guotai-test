//
//  UIAlertControllerExtension.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation
import UIKit

public struct AlertAction {
    public var title : String
    public var style : UIAlertAction.Style
    public var action: ((_ acrion: UIAlertAction) -> Void)?
    
    public init(title: String, style: UIAlertAction.Style, action: ((_ acrion: UIAlertAction) -> Void)?) {
        self.title  = title
        self.style  = style
        self.action = action
    };
};

public struct AlertInput {
    public var placeholder: String?
    public var text       : String?
    public var frame      : AlertInputFrame
    public var types      : [AlertInputType]
    
    public init(placeholder: String?, text: String? = "", frame: AlertInputFrame = .none, types: [AlertInputType]) {
        self.placeholder = placeholder
        self.text        = text
        self.frame       = frame
        self.types       = types
    };
};

public enum AlertInputFrame {
    case border
    case lineTop
    case lineBottom
    case none
};

public enum AlertInputType {
    case font(UIFont)
    case textColor(UIColor)
    case textAlignment(NSTextAlignment)
    case keyboardType(UIKeyboardType)
    case isSecureTextEntry(Bool)
};

extension UIAlertController {
    @discardableResult
    public class func showAlert(alertTitle title: String?, message: String?, actions: [AlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        actions.forEach { (action) in
            alert.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.action));
        };
        
        
        if #available(iOS 13, *) {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil);
        } else {
            alert.presentInOwnWindow(animated: true, completion: nil)
        }
        return alert
    };
    
    @discardableResult
    public class func showAlert(actionSheetTitle title: String?, message: String?, actions: [AlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        actions.forEach { (action) in
            alert.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.action));
        };
        if #available(iOS 13, *) {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil);
        } else {
            alert.presentInOwnWindow(animated: true, completion: nil)
        }
        return alert
    };
    
    @discardableResult
    public class func showAlert(inputTitle title: String?, message: String?, inputs: [AlertInput], comfirm: (String, ([String])->()), actions: [AlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        
        inputs.forEach { (input) in
            alert.addTextField { (texefield) in
                texefield.leftView      = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0));
                texefield.leftViewMode  = .always;
                texefield.rightView     = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0));
                texefield.rightViewMode = .always;
                texefield.placeholder = input.placeholder;
                texefield.text = input.text;
                input.types.forEach {
                    switch $0 {
                    case .font(let font) : texefield.font = font;
                    case .textColor(let color): texefield.textColor = color;
                    case .textAlignment(let textAlignment): texefield.textAlignment = textAlignment;
                    case .keyboardType(let keyboardType) : texefield.keyboardType = keyboardType;
                    case .isSecureTextEntry(let isSecure): texefield.isSecureTextEntry = isSecure;
                    };
                };
                
                guard let h = texefield.font?.pointSize else { return };
                texefield.heightAnchor.constraint(equalToConstant: h*2).isActive = true;
                
                switch input.frame {
                case .border:
                    texefield.layer.cornerRadius  = h;
                    texefield.layer.masksToBounds = true;
                    texefield.layer.borderWidth = 0.5;
                    texefield.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor;
                    
                case .lineTop, .lineBottom:
                    let line: UIView = {
                        let view = UIView()
                        view.translatesAutoresizingMaskIntoConstraints = false;
                        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25);
                        return view
                    }()
                    texefield.addSubview(line);
                    
                    if input.frame == .lineBottom {
                        line.topAnchor.constraint(equalTo: texefield.bottomAnchor, constant: 0).isActive  = true;
                    } else {
                        line.bottomAnchor.constraint(equalTo: texefield.topAnchor, constant: -5).isActive = true;
                    }
                    line.leftAnchor.constraint(equalTo: texefield.leftAnchor, constant: 15).isActive    = true;
                    line.rightAnchor.constraint(equalTo: texefield.rightAnchor, constant: -15).isActive = true;
                    line.heightAnchor.constraint(equalToConstant: 0.5).isActive                         = true;
                case .none: break
                }
                
            }
        }
        
        alert.addAction(
            UIAlertAction(title: comfirm.0, style: .default, handler: { (action: UIAlertAction) -> Void in
                var ary: [String] = [];
                alert.textFields?.forEach {
                    ary.append($0.text ?? "");
                    if ($0 == alert.textFields?.last) {
                        comfirm.1(ary);
                    };
                };
            })
        );
        
        actions.forEach { (action) in
            alert.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.action));
        };
        
        if #available(iOS 13, *) {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil);
        } else {
            alert.presentInOwnWindow(animated: true, completion: nil)
        }
        
        alert.textFields?.forEach {
            if let container = $0.superview, let effectView = container.superview?.subviews.first, effectView is UIVisualEffectView {
                container.backgroundColor = .clear;
                effectView.removeFromSuperview();
            };
        };
        return alert
    };
    
}

extension UIAlertController {

    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }

}

