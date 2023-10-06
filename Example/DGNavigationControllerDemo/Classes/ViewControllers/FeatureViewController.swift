//
//  FeatureViewController.swift
//  DGNavigationControllerDemo
//
//  Created by Xiao Jin on 2021/6/11.
//  Copyright © 2021 debugeek. All rights reserved.
//

import UIKit

class FeatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
    }
    
}

class FirstFeatureViewController: FeatureViewController {

}

class SecondFeatureViewController: FeatureViewController {

}

class ThirdFeatureViewController: FeatureViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Root", style: .plain, target: self, action: #selector(popToRootItemDidPressed)),
            UIBarButtonItem(title: "First", style: .plain, target: self, action: #selector(popToFirstItemDidPressed))
        ]
    }
    
    @objc func popToRootItemDidPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func popToFirstItemDidPressed() {
        if let targetViewController = navigationController?.viewControllers.last(where: { $0 is FirstFeatureViewController }) {
            navigationController?.popToViewController(targetViewController, animated: true)
        }
    }
    
}

class TintColorFeatureViewController: FeatureViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionItemDidPressed))
        ]
    }
    
    @objc func actionItemDidPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredNavigationBarTintColor: UIColor? {
        return UIColor(hex: 0x999999)
    }
    
    override var preferredNavigationBarBackgroundColor: UIColor? {
        return UIColor(hex: 0x222222)
    }
    
    override var preferredNavigationBarTitleTextColor: UIColor? {
        return UIColor(hex: 0x999999)
    }
    
}

class BackItemFeatureViewController: FeatureViewController {

    override var preferredNavigationBarBackButtonTitle: String? {
        return "Return"
    }
    
    override var preferredNavigationBarBackIndicatorImage: UIImage? {
        return UIImage(color: .systemBlue, size: CGSize(width: 8, height: 20))
    }

    override var preferredNavigationBarBackIndicatorTransitionMaskImage: UIImage? {
        return UIImage(color: .systemBlue, size: CGSize(width: 8, height: 20))
    }

}

class SeparatorFeatureViewController: FeatureViewController {

    override var prefersNavigationBarSeparatorHidden: Bool {
        return false
    }
    
    override var preferredNavigationBarSeparatorColor: UIColor? {
        return .systemBlue
    }
    
    override var prefersNavigationBarSeparatorHeight: CGFloat {
        return 1
    }

}

class TitleTextAttributesFeatureViewController: FeatureViewController {

    override var preferredNavigationBarTitleTextAttributes: [NSAttributedString.Key : Any]? {
        return [.foregroundColor: UIColor.systemBlue, .font: UIFont.italicSystemFont(ofSize: 20)]
    }

}

class TitleViewFeatureViewController: FeatureViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var defaultColor: UIColor
        var highlightedColor: UIColor
        if #available(iOS 13.0, *) {
            defaultColor = .quaternaryLabel
            highlightedColor = .label
        } else {
            defaultColor = .darkText
            highlightedColor = .lightText
        }
        
        let segmentedControl = UISegmentedControl(items: ["First", "Second"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([.foregroundColor: defaultColor], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: highlightedColor], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: highlightedColor], for: .highlighted)
        segmentedControl.setTitleTextAttributes([.foregroundColor: highlightedColor], for: [.highlighted, .selected])
        navigationItem.titleView = segmentedControl
    }

}

class LargeTitleFeatureViewController: FeatureViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.prompt = "Prompt"
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    override var preferredNavigationBarLargeTitleTextAttributes: [NSAttributedString.Key : Any]? {
        return [.foregroundColor: UIColor.systemBlue, .font: UIFont.italicSystemFont(ofSize: 32)]
    }
    
}
