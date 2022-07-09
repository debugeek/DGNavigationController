//
//  DGNavigationController.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2020 debugeek. All rights reserved.
//

import UIKit

open class DGNavigationController : UINavigationController {
    
    var inTransition: Bool = false

    var delegateProxy: DGNavigationControllerDelegateProxy?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        let viewControllers = self.viewControllers
        self.viewControllers = viewControllers.map { $0.wrapped() }
    }
    
    required public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController.wrapped())
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        super.setNavigationBarHidden(true, animated: false)

        delegateProxy = DGNavigationControllerDelegateProxy(navigationController: self)
        super.delegate = delegateProxy;

        interactivePopGestureRecognizer?.delaysTouchesBegan = true
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
}

extension DGNavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if inTransition {
            return false
        }

        let viewControllers = viewControllers.map { $0.unwrapped() }
        if viewControllers.count <= 1 {
            return false
        }

        return viewControllers.last?.prefersInteractivePopGestureRecognizerEnabled ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer == self.interactivePopGestureRecognizer)
    }

}


extension DGNavigationController {

    open override var isNavigationBarHidden: Bool {
        get { return super.isNavigationBarHidden }
        set {}
    }

    open override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) { }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if inTransition {
            return
        }
        super.pushViewController(viewController, animated: animated)
    }

    open override func popViewController(animated: Bool) -> UIViewController? {
        if inTransition {
            return nil
        }
        return super.popViewController(animated: animated)
    }

    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if inTransition {
            return nil
        }
        return super.popToRootViewController(animated: animated)
    }

    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if inTransition {
            return nil
        }
        return super.popToViewController(viewController, animated: animated)
    }

    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if inTransition {
            return
        }
        super.setViewControllers(viewControllers, animated: animated)
    }

    open override var delegate: UINavigationControllerDelegate? {
        set { delegateProxy?.target = newValue as? NSObject }
        get { return delegateProxy?.target as? UINavigationControllerDelegate? ?? nil }
    }
    
}
