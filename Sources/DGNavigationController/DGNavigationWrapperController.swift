//
//  DGNavigationWrapperController.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2020 debugeek. All rights reserved.
//

import UIKit

class DGNavigationWrapperController : UIViewController {

    let wrappedViewController: UIViewController
    let transitionController: DGNavigationTransitionController

    init(wrappedViewController: UIViewController) {
        self.wrappedViewController = wrappedViewController
        self.transitionController = DGNavigationTransitionController(rootViewController: wrappedViewController)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(transitionController)
        transitionController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(transitionController.view)
        transitionController.didMove(toParent: self)
    }

}

extension DGNavigationWrapperController {
    
    override func becomeFirstResponder() -> Bool {
        return wrappedViewController.becomeFirstResponder()
    }

    override var canBecomeFirstResponder: Bool {
        get { wrappedViewController.canBecomeFirstResponder }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { wrappedViewController.preferredStatusBarStyle }
    }
    
    override var prefersStatusBarHidden: Bool {
        get { wrappedViewController.prefersStatusBarHidden }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get { wrappedViewController.preferredStatusBarUpdateAnimation }
    }

    override var shouldAutorotate: Bool {
        get { wrappedViewController.shouldAutorotate }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { wrappedViewController.supportedInterfaceOrientations }
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get { wrappedViewController.preferredInterfaceOrientationForPresentation }
    }

    override var hidesBottomBarWhenPushed: Bool {
        get { wrappedViewController.hidesBottomBarWhenPushed }
        set { wrappedViewController.hidesBottomBarWhenPushed = newValue }
    }

    override var title: String? {
        get { wrappedViewController.title }
        set { wrappedViewController.title = newValue; }
    }
    
    override var tabBarItem: UITabBarItem! {
        get { wrappedViewController.tabBarItem }
        set { wrappedViewController.tabBarItem = newValue }
    }
    
}

