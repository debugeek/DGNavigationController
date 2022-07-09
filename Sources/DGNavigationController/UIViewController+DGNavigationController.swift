//
//  UIViewController+DGNavigationController.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2020 debugeek. All rights reserved.
//

import UIKit
import DGFoundation

@objc public enum DGNavigationBarStyle: Int {
    case `default`
    case opaque
    case translucent
}

extension UIViewController {
    
    @objc open var prefersInteractivePopGestureRecognizerEnabled: Bool {
        return true
    }
    
    @objc open var prefersNavigationBarHidden: Bool {
        return false
    }
    
    @objc open var preferredNavigationBarStyle: DGNavigationBarStyle {
        return .opaque
    }
    
    @objc open var preferredNavigationBarTintColor: UIColor? {
        return nil
    }
    
    @objc open var preferredNavigationBarBackgroundColor: UIColor? {
        return nil
    }
    
    @objc open var preferredNavigationBarTitleTextColor: UIColor? {
        return nil
    }
    
    @objc open var preferredNavigationBarTitleTextAttributes: [NSAttributedString.Key : Any]? {
        return nil
    }
    
    @objc open var preferredNavigationBarLargeTitleTextColor: UIColor? {
        return nil
    }
    
    @objc open var preferredNavigationBarLargeTitleTextAttributes: [NSAttributedString.Key : Any]? {
        return nil
    }
    
    @objc open var prefersNavigationBarSeparatorHidden: Bool {
        return true
    }
    
    @objc open var preferredNavigationBarSeparatorColor: UIColor? {
        if #available(iOS 13.0, *) {
            return .opaqueSeparator
        } else {
            return .systemGray
        }
    }
    
    @objc open var prefersNavigationBarSeparatorHeight: CGFloat {
        return 0.5
    }

    @objc open var preferredNavigationBarBackButtonTitle: String? {
        return nil
    }
    
    @objc open var preferredNavigationBarBackIndicatorImage: UIImage? {
        return nil
    }

    @objc open var preferredNavigationBarBackIndicatorTransitionMaskImage: UIImage? {
        return nil
    }
    
    @objc open var prefersToCustomize: Bool {
        return false
    }
    
}

extension UIViewController {
    
    static var wrapperRefKey: UInt8 = 0
    
    func unwrapped() -> UIViewController {
        return (self as? DGNavigationWrapperController)?.wrappedViewController ?? self
    }

    func wrapped() -> UIViewController {
        if let wrapperRef = objc_getAssociatedObject(self, &Self.wrapperRefKey) as? DGWeakReference,
           let wrapper = wrapperRef.target as? DGNavigationWrapperController {
            return wrapper
        } else if self is DGNavigationWrapperController {
            return self
        } else {
            let wrapper = DGNavigationWrapperController(wrappedViewController: self)
            let wrapperRef = DGWeakReference(target: wrapper)
            objc_setAssociatedObject(self, &Self.wrapperRefKey, wrapperRef, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return wrapper
        }
    }
    
}

extension UIViewController {
    
    func configure(navigationItem: UINavigationItem, navigationBar: UINavigationBar) {
        if prefersToCustomize {
            return
        }
        
        navigationController?.isNavigationBarHidden = prefersNavigationBarHidden

        let navigationBarStyle = preferredNavigationBarStyle
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()

            if navigationBarStyle == .opaque {
                appearance.configureWithOpaqueBackground()
                if let backgroundColor = preferredNavigationBarBackgroundColor {
                    appearance.backgroundColor = backgroundColor
                }
            } else if navigationBarStyle == .translucent {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithDefaultBackground()
            }

            appearance.setBackIndicatorImage(preferredNavigationBarBackIndicatorImage, transitionMaskImage: preferredNavigationBarBackIndicatorTransitionMaskImage)
            
            if let tintColor = preferredNavigationBarTintColor {
                navigationBar.tintColor = tintColor
            }
            
            var titleTextAttributes = [NSAttributedString.Key: Any]()
            UINavigationBar.appearance().titleTextAttributes?.forEach({ (k, v) in
                titleTextAttributes.updateValue(v, forKey: k)
            })
            preferredNavigationBarTitleTextAttributes?.forEach({ (k, v) in
                titleTextAttributes.updateValue(v, forKey: k)
            })
            if let titleTextColor = preferredNavigationBarTitleTextColor {
                titleTextAttributes[.foregroundColor] = titleTextColor
            }
            appearance.titleTextAttributes = titleTextAttributes

            var largeTitleTextAttributes = [NSAttributedString.Key: Any]()
            UINavigationBar.appearance().largeTitleTextAttributes?.forEach({ (k, v) in
                largeTitleTextAttributes.updateValue(v, forKey: k)
            })
            preferredNavigationBarLargeTitleTextAttributes?.forEach({ (k, v) in
                largeTitleTextAttributes.updateValue(v, forKey: k)
            })
            if let largeTitleTextColor = preferredNavigationBarLargeTitleTextColor {
                largeTitleTextAttributes[.foregroundColor] = largeTitleTextColor
            }
            appearance.largeTitleTextAttributes = largeTitleTextAttributes

            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.backIndicatorImage = preferredNavigationBarBackIndicatorImage
            navigationBar.backIndicatorTransitionMaskImage = preferredNavigationBarBackIndicatorTransitionMaskImage

            if navigationBarStyle == .opaque {
                navigationBar.isTranslucent = false
                if let backgroundColor = preferredNavigationBarBackgroundColor {
                    navigationBar.barTintColor = backgroundColor
                }
            } else if navigationBarStyle == .translucent {
                navigationBar.isTranslucent = true
                navigationBar.shadowImage = UIImage()
                navigationBar.setBackgroundImage(UIImage(), for:.default)
            } else {
                navigationBar.isTranslucent = true
                if let backgroundColor = preferredNavigationBarBackgroundColor {
                    navigationBar.barTintColor = backgroundColor
                }
            }

            if let tintColor = preferredNavigationBarTintColor {
                navigationBar.tintColor = tintColor
            }
            
            var titleTextAttributes = [NSAttributedString.Key: Any]()
            UINavigationBar.appearance().titleTextAttributes?.forEach({ (k, v) in
                titleTextAttributes.updateValue(v, forKey: k)
            })
            preferredNavigationBarTitleTextAttributes?.forEach({ (k, v) in
                titleTextAttributes.updateValue(v, forKey: k)
            })
            if let titleTextColor = preferredNavigationBarTitleTextColor {
                titleTextAttributes[.foregroundColor] = titleTextColor
            }
            navigationBar.titleTextAttributes = titleTextAttributes

            if #available(iOS 11.0, *) {
                var largeTitleTextAttributes = [NSAttributedString.Key: Any]()
                UINavigationBar.appearance().largeTitleTextAttributes?.forEach({ (k, v) in
                    largeTitleTextAttributes.updateValue(v, forKey: k)
                })
                preferredNavigationBarLargeTitleTextAttributes?.forEach({ (k, v) in
                    largeTitleTextAttributes.updateValue(v, forKey: k)
                })
                if let largeTitleTextColor = preferredNavigationBarLargeTitleTextColor {
                    largeTitleTextAttributes[.foregroundColor] = largeTitleTextColor
                }
                navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
            }
        }
    }
    
}
