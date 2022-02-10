//
//  AZNavigationPopSwiper.swift
//  AZNavigationPopSwiper
//
//  Created by minkook yoo on 2022/01/21.
//

import Foundation
import UIKit


@objc
open class AZNavigationPopSwiper: NSObject {
    
    // MARK: Public
    public var enable: Bool = true
    
    
    // MARK: Private
    weak var navigationController: UINavigationController?
    var panRecognizer: AZNPSPanGestureRecognizer?
    var animator: AZNPSAnimator?
    var interactionController: UIPercentDrivenInteractiveTransition?
    var duringAnimation = false
    
    
    public init(navigationController: UINavigationController) {
        super.init()
        
        self.navigationController = navigationController
        if let nc = self.navigationController {
            nc.delegate = self
        }
        
        commonInit()
    }
    
    func commonInit() {
        // pan
        panRecognizer = AZNPSPanGestureRecognizer.init(target: self, action: #selector(pan(_:)))
        if let panRecognizer = panRecognizer {
            panRecognizer.maximumNumberOfTouches = 1
            panRecognizer.delegate = self
            
            if let nc = navigationController {
                nc.view.addGestureRecognizer(panRecognizer)
            }
        }
        
        // animator
        animator = AZNPSAnimator()
    }
    
}


// MARK: UIGestureRecognizerDelegate
extension AZNavigationPopSwiper: UIGestureRecognizerDelegate {
    
    @objc func pan(_ recognizer: UIPanGestureRecognizer) {
        
        guard let nc = navigationController else { return }
        guard let view = nc.view else { return }
        
        switch recognizer.state {
        case .began:
            if nc.viewControllers.count > 1 && !duringAnimation {
                interactionController = UIPercentDrivenInteractiveTransition()
                if let interactionController = interactionController {
                    interactionController.completionCurve = .easeOut
                }
                nc.popViewController(animated: true)
            }
            
        case .changed:
            let translation = recognizer.translation(in: view)
            let d = translation.x > 0 ? translation.x / view.bounds.width : 0
            if let interactionController = interactionController {
                interactionController.update(d)
            }
            
        case .ended, .cancelled:
            if let interactionController = interactionController {
                if recognizer.velocity(in: view).x > 0 {
                    interactionController.finish()
                } else {
                    interactionController.cancel()
                    duringAnimation = false
                }
            }
            interactionController = nil
            
        default:
            break
        }

    }
    
    private func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = navigationController else { return false }
        
        if navigationController.viewControllers.count > 1 {
            return true
        }
        return false
    }
}



// MARK: UINavigationControllerDelegate
extension AZNavigationPopSwiper: UINavigationControllerDelegate {
    
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return animator
        }
        return nil
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated {
            duringAnimation = true
        }
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        duringAnimation = false
        
        if let panRecognizer = panRecognizer {
            if enable {
                panRecognizer.isEnabled = navigationController.viewControllers.count <= 1 ? false : true
            } else {
                panRecognizer.isEnabled = false
            }
        }
    }
    
}
