//  
//  DGNavigationBar.swift
//  DGNavigationController
//
//  Created by Xiao Jin on 2020/5/17.
//  Copyright © 2020 debugeek. All rights reserved.
//

import UIKit
import DGExtension

class DGNavigationBar: UINavigationBar {

    var separatorLayer: CALayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let transitionController = delegate as? DGNavigationTransitionController,
              let wrapperController = transitionController.parent as? DGNavigationWrapperController else {
            return
        }
        
        let wrappedViewController = wrapperController.wrappedViewController
        if wrappedViewController.prefersToCustomize {
            return
        }
        
        enumerateSubviews(recursively: true) { (subview, stop) in
            if subview is UIImageView,
               subview.bounds.size.height > 0,
               subview.bounds.size.height < 1 {
                subview.isHidden = true
                stop.pointee = true
            }
        }
        
        if separatorLayer == nil {
            let separatorLayer = CALayer()
            layer.addSublayer(separatorLayer)
            self.separatorLayer = separatorLayer
        }
        
        if let separatorLayer = separatorLayer {
            separatorLayer.isHidden = wrappedViewController.prefersNavigationBarSeparatorHidden
            separatorLayer.backgroundColor = wrappedViewController.preferredNavigationBarSeparatorColor?.cgColor
        
            let separatorHeight = wrappedViewController.prefersNavigationBarSeparatorHeight
            separatorLayer.frame = CGRect(x: 0, y: height - separatorHeight, width: width, height: separatorHeight)
        }
    }
    
}
