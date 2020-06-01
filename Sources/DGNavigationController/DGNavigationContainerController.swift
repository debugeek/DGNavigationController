//
//  DGNavigationContainerController.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2017 debugeek. All rights reserved.
//

import UIKit

class DGNavigationContainerController : UIViewController {

    var contentViewController: UIViewController
    var containerNavigationController: DGNavigationTransitionController

    init(contentViewController: UIViewController!) {
        self.contentViewController = contentViewController
        self.containerNavigationController = DGNavigationTransitionController(navigationBarClass: DGNavigationBar.self, toolbarClass: nil)
        containerNavigationController.embedViewController(contentViewController)

        super.init(nibName: nil, bundle: nil)
        
        addChild(self.containerNavigationController)
        containerNavigationController.didMove(toParent: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerNavigationController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(containerNavigationController.view)
        containerNavigationController.view.frame = view.bounds
    }

    override func becomeFirstResponder() -> Bool {
        return self.contentViewController.becomeFirstResponder()
    }

    override var canBecomeFirstResponder: Bool {
        get { contentViewController.canBecomeFirstResponder }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { contentViewController.preferredStatusBarStyle }
    }
    
    override var prefersStatusBarHidden: Bool {
        get { contentViewController.prefersStatusBarHidden }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get { contentViewController.preferredStatusBarUpdateAnimation }
    }

    override var shouldAutorotate: Bool {
        get { contentViewController.shouldAutorotate }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { contentViewController.supportedInterfaceOrientations }
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get { contentViewController.preferredInterfaceOrientationForPresentation }
    }

    override var hidesBottomBarWhenPushed: Bool {
        get { contentViewController.hidesBottomBarWhenPushed }
        set { contentViewController.hidesBottomBarWhenPushed = newValue }
    }

    override var title: String? {
        get { contentViewController.title }
        set { contentViewController.title = newValue; }
    }
    
    override var tabBarItem: UITabBarItem! {
        get { contentViewController.tabBarItem }
        set { contentViewController.tabBarItem = newValue }
    }
    
}

