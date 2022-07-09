//
//  DGNavigationTransitionController.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2020 debugeek. All rights reserved.
//

import UIKit

class DGNavigationTransitionController : UINavigationController {

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: DGNavigationBar.self, toolbarClass: nil)
        super.setViewControllers([DGNavigationTransitionPlaceholderController(), rootViewController], animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.isEnabled = false

        let viewControllers = self.viewControllers

        guard let wrappedViewController = viewControllers.last,
              let navigationController = wrappedViewController.navigationController else {
            return
        }

        let navigationItem = wrappedViewController.navigationItem
        
        navigationItem.title = wrappedViewController.title

        if viewControllers.count <= 1 {
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.hidesBackButton = false
        }

        let navigationBar = navigationController.navigationBar
        
        if viewControllers.count > 1 {
            if let index = viewControllers.firstIndex(of: wrappedViewController),
               let placeholderController = super.viewControllers.first as? DGNavigationTransitionPlaceholderController {
                if let backButtonTitle = wrappedViewController.preferredNavigationBarBackButtonTitle {
                    placeholderController.title = backButtonTitle;
                } else {
                    let previousViewController = viewControllers[index - 1]
                    placeholderController.title = previousViewController.title
                }
            }
        }
        
        wrappedViewController.configure(navigationItem: navigationItem, navigationBar: navigationBar)
    }
    
    override var tabBarController: UITabBarController? {
        get { navigationController?.tabBarController }
    }
    
    override var delegate: UINavigationControllerDelegate? {
        get { navigationController?.delegate }
        set { navigationController?.delegate = newValue }
    }
    
    override var viewControllers: [UIViewController] {
        get { navigationController?.viewControllers.map { $0.unwrapped() } ?? [] }
        set { navigationController?.viewControllers = newValue.map { $0.wrapped() } }
    }
    
    override var title: String? {
        get { navigationController?.title }
        set { navigationController?.title = newValue }
    }

    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let wrapperController = viewController.wrapped()
        wrapperController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(wrapperController, animated: animated)
    }

    open override func popViewController(animated: Bool) -> UIViewController? {
        return navigationController?.popViewController(animated: animated)?.unwrapped()
    }

    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return navigationController?.popToRootViewController(animated: animated)?.map({ $0.unwrapped() })
    }

    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard let target = navigationController?.viewControllers.last(where: {
            ($0 as? DGNavigationWrapperController)?.wrappedViewController == viewController
        }) else {
            return nil
        }
        return navigationController?.popToViewController(target, animated: animated)?.map { $0.unwrapped() }
    }

    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        navigationController?.setViewControllers(viewControllers.enumerated().map {
            let wrapperController = $1.wrapped()
            wrapperController.hidesBottomBarWhenPushed = $0 > 0
            return wrapperController
        }, animated: animated)
    }
    
}

private class DGNavigationTransitionPlaceholderController : UIViewController { }
