//
//  DGNavigationController.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2020 debugeek. All rights reserved.
//

import UIKit

open class DGNavigationController : UINavigationController {
    
    var context = DGNavigationTransitionContext()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewControllers = self.viewControllers()
    }
    
    required public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController.dg_viewControllerByWrapping())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func viewControllers() -> [UIViewController] {
        return viewControllers.map({ $0.dg_viewControllerByUnwrapping() })
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        super.setNavigationBarHidden(true, animated: false)
        super.delegate = self;

        interactivePopGestureRecognizer?.delaysTouchesBegan = true
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension DGNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let viewController = viewController as? DGNavigationContainerController {
            let contentViewController = viewController.contentViewController

            if let navigationBar = viewController.containerNavigationController.navigationBar as? DGNavigationBar {
                navigationBar.separatorLayer.isHidden = contentViewController.dg_navigationBarSeparatorHidden
                navigationBar.separatorLayer.backgroundColor = contentViewController.dg_navigationBarSeparatorColor?.cgColor

                if contentViewController.dg_navigationBarHidden {
                    contentViewController.navigationController?.isNavigationBarHidden = true
                }

                if let containerController = navigationController.viewControllers.first as? DGNavigationContainerController, contentViewController != containerController.contentViewController {
                    
                }
            }
        }

        self.context.transition = true

        if #available(iOS 10.0, *) {
            self.transitionCoordinator?.notifyWhenInteractionChanges({ context in
                if context.isCancelled {
                    self.context.transition = false
                }
            })
        }

        if let delegate = context.realDelegate, delegate .responds(to: #selector(UINavigationControllerDelegate.navigationController(_:willShow:animated:))) {
            delegate.navigationController?(navigationController, willShow: viewController, animated: true)
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        context.transition = false

        UIViewController.attemptRotationToDeviceOrientation()

        if let delegate = context.realDelegate, delegate .responds(to: #selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:))) {
            delegate.navigationController?(navigationController, didShow: viewController, animated: true)
        }
    }

    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let delegate = context.realDelegate, delegate.responds(to: aSelector) {
            return delegate
        }
        return nil
    }

}

extension DGNavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if context.transition {
            return false
        }

        if viewControllers.count <= 1 {
            return false
        }

        if let viewController = topViewController as? DGNavigationContainerController {
            let contentViewController = viewController.contentViewController
            return contentViewController.dg_interactivePopGestureRecognizerEnabled
        }

        return false
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
        get {
            return super.isNavigationBarHidden
        } set {}
    }

    open override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {

    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if context.transition {
            return
        }
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController.dg_viewControllerByWrapping(), animated: animated)
    }

    open override func popViewController(animated: Bool) -> UIViewController? {
        if context.transition {
            return nil
        }
        return super.popViewController(animated: animated)?.dg_viewControllerByUnwrapping()
    }

    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if context.transition {
            return nil
        }
        return super.popToRootViewController(animated: animated)?.map({ $0.dg_viewControllerByUnwrapping() })
    }

    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if context.transition {
            return nil
        }

        var targetViewController: UIViewController?
        for childViewController in viewControllers {
            if childViewController == viewController {
                targetViewController = childViewController
                break
            } else if let childViewController = childViewController as? DGNavigationContainerController, childViewController.contentViewController == viewController {
                targetViewController = childViewController
            }
        }

        if let targetViewController = targetViewController {
            return super.popToViewController(targetViewController, animated: animated)?.map({ $0.dg_viewControllerByUnwrapping() })
        }

        return nil;
    }

    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if context.transition {
            return
        }
        let wrappedViewControllers: [UIViewController] = viewControllers.enumerated().map({ (index, viewController) in
            if index > 0 {
                viewController.hidesBottomBarWhenPushed = true
            }
            return viewController.dg_viewControllerByWrapping()
        })
        super.setViewControllers(wrappedViewControllers, animated: animated)
    }

    open override var delegate: UINavigationControllerDelegate? {
        set {
            context.realDelegate = newValue
        } get {
            return context.realDelegate
        }
    }
    
}


