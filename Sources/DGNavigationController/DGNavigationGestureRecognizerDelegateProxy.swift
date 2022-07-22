//
//  DGNavigationGestureRecognizerDelegateProxy.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2022/7/22.
//  Copyright © 2022 debugeek. All rights reserved.
//

import UIKit
import DGFoundation

class DGNavigationGestureRecognizerDelegateProxy: DGWeakProxy {
    
    var shouldBeginBlock: ((_ gestureRecognizer: UIGestureRecognizer) -> Bool)?
    var shouldRecognizeSimultaneouslyBlock: ((_ gestureRecognizer: UIGestureRecognizer, _ otherGestureRecognizer: UIGestureRecognizer) -> Bool)?
    
    weak var navigationController: DGNavigationController?
    
    init(navigationController: DGNavigationController) {
        self.navigationController = navigationController
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(gestureRecognizerShouldBegin(_:)) ||
            aSelector == #selector(gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)) {
            return true
        }
        return false
    }
    
}

extension DGNavigationGestureRecognizerDelegateProxy: UIGestureRecognizerDelegate {
    
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let result = (self.target as? UIGestureRecognizerDelegate)?.gestureRecognizerShouldBegin?(gestureRecognizer) ?? false
        if !result {
            return false
        }
        
        guard let navigationController = navigationController else {
            return false
        }
        
        if navigationController.inTransition {
            return false
        }
        
        guard gestureRecognizer == navigationController.interactivePopGestureRecognizer,
              let panGestureRecognizer = navigationController.interactivePopGestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        if velocity.x < .ulpOfOne || abs(velocity.x) <= abs(velocity.y) {
            return false
        }
        
        let location = panGestureRecognizer.location(in: panGestureRecognizer.view)
        if let control = panGestureRecognizer.view?.hitTest(location, with: nil) as? UIControl,
            !(control is UIButton) {
            return false
        }
        
        let viewControllers = navigationController.viewControllers.map { $0.unwrapped() }
        if viewControllers.count <= 1 {
            return false
        }
        
        guard let interactivePopType = viewControllers.last?.preferredNavigationInteractivePopType else {
            return false
        }
        
        switch interactivePopType {
        case .default:
            return location.x < 44
        case .fullScreen:
            return true
        case .disabled:
            return false
        }
    }
    
    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let result = (self.target as? UIGestureRecognizerDelegate)?.gestureRecognizer?(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) ?? false
        if result {
            return true
        }
        
        guard let navigationController = navigationController else {
            return false
        }
        
        if navigationController.inTransition {
            return false
        }
        
        let viewControllers = navigationController.viewControllers
        if viewControllers.count <= 1 {
            return false
        }
        
        guard gestureRecognizer == navigationController.interactivePopGestureRecognizer,
              let panGestureRecognizer = navigationController.interactivePopGestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        if let scrollView = otherGestureRecognizer.view as? UIScrollView {
            let isHorizontal = scrollView.contentSize.height > .ulpOfOne &&
                                scrollView.contentSize.width > scrollView.contentSize.height &&
            abs(scrollView.contentOffset.x + scrollView.contentInset.left) < .ulpOfOne
            let isDecelerating = scrollView.contentSize.height > scrollView.contentSize.width && scrollView.isDecelerating
            if isHorizontal || isDecelerating {
                if isHorizontal {
                    let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
                    if velocity.x < .ulpOfOne {
                        return false
                    }
                    otherGestureRecognizer.isEnabled = false
                    otherGestureRecognizer.isEnabled = true
                }
                return true
            } else {
                let location = panGestureRecognizer.location(in: panGestureRecognizer.view)
                if location.x < 44 {
                    let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
                    if abs(velocity.x) > abs(velocity.y) {
                        otherGestureRecognizer.isEnabled = false
                        otherGestureRecognizer.isEnabled = true
                        return true
                    }
                }
            }
        }
        
        let location = panGestureRecognizer.location(in: panGestureRecognizer.view)
        if location.x < 44 {
            let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
            if abs(velocity.x) > abs(velocity.y) {
                otherGestureRecognizer.isEnabled = false
                otherGestureRecognizer.isEnabled = true
                return true
            }
        }
        
        return false
    }
    
}

class DGNavigationPanGestureRecognizer: UIPanGestureRecognizer {}
