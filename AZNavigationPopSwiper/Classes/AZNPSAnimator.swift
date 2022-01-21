//
//  AZNPSAnimator.swift
//  AZNavigationPopSwiper
//
//  Created by minkook yoo on 2022/01/21.
//

import Foundation

class AZNPSAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let transitionDimAmount: CGFloat = 0.1
    let shouldAnimateTabBar: Bool = true
    
    var toViewController: UIViewController?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let transitionContext = transitionContext {
            if transitionContext.isInteractive {
                return 0.25
            }
        }
        return 0.5;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let toViewControllerXTranslation = (-transitionContext.containerView.bounds.width * 0.3)
        toViewController.view.bounds = transitionContext.containerView.bounds
        toViewController.view.center = transitionContext.containerView.center
        toViewController.view.transform = CGAffineTransform(translationX: toViewControllerXTranslation, y: 0)
        
        fromViewController.view.addLeftSideShadowWithFading()
        let previousClipsToBounds = fromViewController.view.clipsToBounds
        fromViewController.view.clipsToBounds = false
        
        let dimmingView = UIView(frame: toViewController.view.bounds)
        dimmingView.backgroundColor = UIColor.init(white: 0.0, alpha: transitionDimAmount)
        toViewController.view.addSubview(dimmingView)
        
        guard let navController = toViewController.navigationController else { return }
        
        var tabBar: UITabBar?
        var tabBarControllerContainsToViewController = false
        var tabBarControllerContainsNavController = false
        if let tabBarController = toViewController.tabBarController {
            tabBar = tabBarController.tabBar
            
            if let tabBarViewControllers = tabBarController.viewControllers {
                tabBarControllerContainsToViewController = tabBarViewControllers.contains(toViewController)
                tabBarControllerContainsNavController = tabBarViewControllers.contains(navController)
            }
        }
        
        var shouldAddTabBarBackToTabBarController = false
        
        let isToViewControllerFirstInNavController = navController.viewControllers.first == toViewController
        
        if shouldAnimateTabBar {
            
            if let tabBar = tabBar {
                if tabBarControllerContainsToViewController ||
                    (isToViewControllerFirstInNavController && tabBarControllerContainsNavController) {
                    
                    tabBar.layer.removeAllAnimations()
                    
                    var tabBarRect = tabBar.frame
                    tabBarRect.origin.x = toViewController.view.bounds.origin.x
                    tabBar.frame = tabBarRect
                    
                    toViewController.view.addSubview(tabBar)
                    shouldAddTabBarBackToTabBarController = true
                    
                }
            }
            
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        print("duration : \(duration)")
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear]) {
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = CGAffineTransform.init(translationX: toViewController.view.frame.size.width, y: 0)
            dimmingView.alpha = 0.0
        } completion: { finished in
            if shouldAddTabBarBackToTabBarController {
                if let tabBar = tabBar {
                    var tabBarRect = tabBar.frame
                    tabBarRect.origin.x = toViewController.view.bounds.origin.x
                    tabBar.frame = tabBarRect
                }
            }
            
            dimmingView.removeFromSuperview()
            fromViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.clipsToBounds = previousClipsToBounds
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        self.toViewController = toViewController
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            if let toViewController = self.toViewController {
                toViewController.view.transform = CGAffineTransform.identity
            }
        }
    }
}



extension UIView {
    
    func addLeftSideShadowWithFading() {
        
        let shadowWidth = 4.0
        let shadowVerticalPadding = -20.0
        let shadowHeight = self.frame.height - 2 * shadowVerticalPadding
        let shadowRect = CGRect(x: -shadowWidth, y: shadowVerticalPadding, width: shadowWidth, height: shadowHeight)
        
        let shadowPath = UIBezierPath.init(rect: shadowRect)
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowOpacity = 0.2
        
        let toValue: Float = 0.0
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.layer.shadowOpacity
        animation.toValue = toValue
        self.layer.add(animation, forKey: nil)
        self.layer.shadowOpacity = toValue
        
    }
    
}
