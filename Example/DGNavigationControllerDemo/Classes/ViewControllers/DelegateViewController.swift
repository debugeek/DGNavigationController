//
//  DelegateViewController.swift
//  DGNavigationControllerDemo
//
//  Created by Xiao Jin on 2022/6/3.
//  Copyright © 2022 debugeek. All rights reserved.
//

import UIKit

class DelegateViewController: FeatureViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
    }

}

extension DelegateViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("navigationController \(navigationController) didShow \(viewController)")
    }

}
