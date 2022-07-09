//
//  FeatureTableViewController.swift
//  DGNavigationControllerDemo
//
//  Created by Xiao Jin on 2021/6/11.
//  Copyright © 2021 debugeek. All rights reserved.
//

import UIKit
import DGNavigationController

class FeatureTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView = UIView()
        headerView.backgroundColor = .purple
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 320)
        
        let label = UILabel()
        label.text = "A Beautiful Header View"
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        headerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.tableHeaderView = headerView
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .always
        } else {
            self.edgesForExtendedLayout = .all
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "\(indexPath.row + 1)"

        return cell
    }
    
}

class DefaultStyleTableViewController: FeatureTableViewController {

    override var preferredNavigationBarStyle: DGNavigationBarStyle {
        return .default
    }

}

class OpaqueStyleTableViewController: FeatureTableViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var preferredNavigationBarStyle: DGNavigationBarStyle {
        return .opaque
    }

    override var preferredNavigationBarTintColor: UIColor? {
        return UIColor.color(withHex: 0x999999)
    }
    
    override var preferredNavigationBarBackgroundColor: UIColor? {
        return UIColor.color(withHex: 0x222222)
    }
    
    override var preferredNavigationBarTitleTextColor: UIColor? {
        return UIColor.color(withHex: 0x999999)
    }
    
}

class TranslucentStyleTableViewController: FeatureTableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            self.tableView.automaticallyAdjustsScrollIndicatorInsets = true
        }

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var preferredNavigationBarStyle: DGNavigationBarStyle {
        return .translucent
    }

}
