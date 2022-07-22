//
//  DGNavigationControllerDelegateProxy.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2022/6/5.
//  Copyright © 2022 debugeek. All rights reserved.
//

import UIKit
import DGFoundation

class DGNavigationControllerDelegateProxy: DGWeakProxy {

    weak var navigationController: DGNavigationController?

    init(navigationController: DGNavigationController) {
        self.navigationController = navigationController
    }

    override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(navigationController(_:willShow:animated:)) ||
            aSelector == #selector(navigationController(_:didShow:animated:)) {
            return true
        }
        return false
    }

}

extension DGNavigationControllerDelegateProxy: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.navigationController?.inTransition = true

        if #available(iOS 10.0, *) {
            self.navigationController?.transitionCoordinator?.notifyWhenInteractionChanges({ context in
                if context.isCancelled {
                    self.navigationController?.inTransition = false
                }
            })
        }

        if let delegate = target as? UINavigationControllerDelegate {
            delegate.navigationController?(navigationController, willShow: viewController.unwrapped(), animated: true)
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.navigationController?.inTransition = false

        if let delegate = target as? UINavigationControllerDelegate {
            delegate.navigationController?(navigationController, didShow: viewController.unwrapped(), animated: true)
        }
    }

}
