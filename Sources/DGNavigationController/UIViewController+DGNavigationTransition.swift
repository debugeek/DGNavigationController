//
//  UIViewController+DGNavigationTransition.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2017 debugeek. All rights reserved.
//

import UIKit

@objc public enum DGNavigationControllerStyle: Int {
    case Default
    case Translucent
}

@objc public protocol DGViewControllerProtocol {
    
    var dg_interactivePopGestureRecognizerEnabled: Bool { get }
    
    var dg_navigationBarHidden: Bool { get }
    var dg_navigationBarStyle: DGNavigationControllerStyle { get }
    
    var dg_navigationBarBackgroundColor: UIColor? { get }
    var dg_navigationBarTintColor: UIColor? { get }
    
    var dg_navigationBarSeparatorHidden: Bool { get }
    var dg_navigationBarSeparatorColor: UIColor? { get }
    
}

extension UIViewController: DGViewControllerProtocol {
    open var dg_interactivePopGestureRecognizerEnabled: Bool {
        return true
    }
    
    open var dg_navigationBarHidden: Bool {
        return false
    }
    
    open var dg_navigationBarStyle: DGNavigationControllerStyle {
        return .Default
    }
    
    open var dg_navigationBarBackgroundColor: UIColor? {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    open var dg_navigationBarTintColor: UIColor? {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        };
    }
    
    open var dg_navigationBarSeparatorHidden: Bool {
        return false
    }
    
    open var dg_navigationBarSeparatorColor: UIColor? {
        if #available(iOS 13.0, *) {
            return .separator
        } else {
            return .lightGray
        }
    }

}

extension UIViewController {
    
    func dg_transition_navigationController() -> UINavigationController? {
        if let navigationController = self.navigationController, navigationController is DGNavigationTransitionController {
            return navigationController.navigationController
        }
        return navigationController
    }

    func dg_viewControllerByUnwrapping() -> UIViewController {
        if self is DGNavigationContainerController {
            return (self as! DGNavigationContainerController).contentViewController
        }
        return self
    }

    func dg_viewControllerByWrapping() -> UIViewController! {
        if !(self is DGNavigationContainerController) {
            return DGNavigationContainerController(contentViewController: self)
        }
        return self
    }
    
}

