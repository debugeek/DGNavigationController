//
//  FeatureListViewController.swift
//  DGNavigationControllerDemo
//
//  Created by Xiao Jin on 2021/6/11.
//  Copyright © 2021 debugeek. All rights reserved.
//

import UIKit
import DGNavigationController

class FeatureListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let viewController = FeatureViewController()
                navigationController?.pushViewController(viewController, animated: true)

            case 1:
                guard var viewControllers = navigationController?.viewControllers else {
                    return
                }
                viewControllers.append({
                    let viewController = FirstFeatureViewController()
                    viewController.title = "First"
                    return viewController
                }())
                viewControllers.append({
                    let viewController = SecondFeatureViewController()
                    viewController.title = "Second"
                    return viewController
                }())
                viewControllers.append({
                    let viewController = ThirdFeatureViewController()
                    viewController.title = "Third"
                    return viewController
                }())
                navigationController?.setViewControllers(viewControllers, animated: true)

            default: break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeatureListViewController") as? FeatureListViewController else {
                    return
                }
                let navigationController = DGNavigationController(rootViewController: viewController)
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, actionBlock: { [weak navigationController] item in
                    navigationController?.dismiss(animated: true)
                })
                present(navigationController, animated: true)
                
            default: break
            }

        case 2:
            switch indexPath.row {
            case 0:
                let viewController = TintColorFeatureViewController()
                viewController.title = "Tint Color"
                navigationController?.pushViewController(viewController, animated: true)

            case 1:
                let viewController = BackItemFeatureViewController()
                viewController.title = "Back Item"
                navigationController?.pushViewController(viewController, animated: true)

            case 2:
                let viewController = SeparatorFeatureViewController()
                viewController.title = "Separator"
                navigationController?.pushViewController(viewController, animated: true)

            case 3:
                let viewController = TitleTextAttributesFeatureViewController()
                viewController.title = "Title Text Attributes"
                navigationController?.pushViewController(viewController, animated: true)
                
            case 4:
                let viewController = TitleViewFeatureViewController()
                viewController.title = "Title View"
                navigationController?.pushViewController(viewController, animated: true)
                
            case 5:
                let viewController = LargeTitleFeatureViewController()
                viewController.title = "Large Title"
                navigationController?.pushViewController(viewController, animated: true)
                
            default: break
            }

        case 3:
            switch indexPath.row {
            case 0:
                let viewController = DefaultStyleTableViewController()
                navigationController?.pushViewController(viewController, animated: true)
                
            case 1:
                let viewController = OpaqueStyleTableViewController()
                navigationController?.pushViewController(viewController, animated: true)

            case 2:
                let viewController = TranslucentStyleTableViewController()
                navigationController?.pushViewController(viewController, animated: true)

            default: break
            }

        case 4:
            switch indexPath.row {
            case 0:
                let viewController = DelegateViewController()
                navigationController?.pushViewController(viewController, animated: true)

            case 1:
                let viewController = CustomViewController()
                navigationController?.pushViewController(viewController, animated: true)
                
            default: break
            }

        default: break
        }

    }
    
    override var prefersNavigationBarSeparatorHidden: Bool {
        return false
    }

}
