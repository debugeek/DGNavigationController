//
//  InteractivePopGestureViewController.swift
//  DGNavigationControllerDemo
//
//  Created by Xiao Jin on 2022/7/22.
//  Copyright © 2022 debugeek. All rights reserved.
//

import UIKit
import MapKit
import DGNavigationController

class InteractivePopGestureViewController: UITableViewController {
    
    var segmentedControl: UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl = UISegmentedControl(items: ["Default", "FullScreen", "Disabled"])
        segmentedControl?.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl
    }
    
    override var preferredNavigationInteractivePopType: DGNavigationInteractivePopType {
        guard let segmentedControl = segmentedControl else {
            return .default
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case 1: return .fullScreen
        case 2: return .disabled
        default: return .default
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

