//  
//  DGNavigationBar.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2020 debugeek. All rights reserved.
//

import UIKit

class DGNavigationBar: UINavigationBar {

    var separatorLayer = CALayer()
    var managed = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.managed {
            var managed = false
            foreachSubview(recursively: true) { subview -> (Bool) in
                if subview is UIImageView, subview.bounds.size.height > 0, subview.bounds.size.height < 1 {
                    subview.isHidden = true
                    managed = true
                    return false
                }
                return true
            }
            
            if managed {
                self.managed = true
                layer.addSublayer(separatorLayer)
            }
        }
        
        if self.managed {
            if let transitionController = delegate as? DGNavigationTransitionController, let containerViewController = transitionController.parent as? DGNavigationContainerController {
                let contentViewController = containerViewController.contentViewController
                separatorLayer.isHidden = contentViewController.dg_navigationBarSeparatorHidden
                separatorLayer.backgroundColor = contentViewController.dg_navigationBarSeparatorColor?.cgColor
            }
            
            let separatorHeight = 1.0/UIScreen.main.scale
            separatorLayer.frame = CGRect(x: 0, y: height - separatorHeight, width: width, height: separatorHeight)
        }
    }

}
