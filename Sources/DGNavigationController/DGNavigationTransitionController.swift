//
//  DGNavigationTransitionController.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2017 debugeek. All rights reserved.
//

import UIKit

class DGNavigationTransitionController : UINavigationController {

    private class DGNavigationTransitionPlaceholderController : UIViewController { }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.isEnabled = false
        
        if let viewController = self.viewControllers.last as? DGNavigationContainerController {
            let contentViewController = viewController.contentViewController
            
            let style = contentViewController.dg_navigationBarStyle
            if style == .Translucent {
                navigationBar.isTranslucent = true
                navigationBar.setBackgroundImage(UIColor.clear.image(), for: .default)
            } else {
                navigationBar.isTranslucent = false
                navigationBar.setBackgroundImage(nil, for:.default)
            }

            if let barTintColor = contentViewController.dg_navigationBarBackgroundColor {
                navigationBar.barTintColor = barTintColor
            }
            
            if let tintColor = contentViewController.dg_navigationBarTintColor {
                navigationBar.tintColor = tintColor
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor]
            }
            
            if navigationController?.viewControllers.count == 1 {
                topViewController?.navigationItem.hidesBackButton = true
            }
            
            if let title = contentViewController.title {
                topViewController?.navigationItem.title = title
            }
        }
    }
    
    func embedViewController(_ viewController: UIViewController) {
        super.setViewControllers([DGNavigationTransitionPlaceholderController(), viewController], animated: false)
    }
    
    override var tabBarController: UITabBarController? {
        get { navigationController?.tabBarController }
    }
    
    override var delegate: UINavigationControllerDelegate? {
        get { navigationController?.delegate }
        set { navigationController?.delegate = newValue }
    }
    
    override var viewControllers: [UIViewController] {
        get { navigationController?.viewControllers ?? [] }
        set { navigationController?.viewControllers = newValue }
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if navigationController?.responds(to: aSelector) ?? false {
            return navigationController
        }
        return nil
    }
    
    override var title: String? {
        get { navigationController?.title }
        set { navigationController?.title = newValue }
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        navigationController?.setViewControllers(viewControllers, animated:animated)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated:animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        return self.navigationController?.popViewController(animated: animated)
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return self.navigationController?.popToRootViewController(animated: animated)
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return self.navigationController?.popToViewController(viewController, animated:animated)
    }
    
}
