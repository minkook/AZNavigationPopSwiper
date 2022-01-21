//
//  AZNPSPanGestureRecognizer.swift
//  AZNavigationPopSwiper
//
//  Created by minkook yoo on 2022/01/21.
//

import Foundation

enum NPSPanDirection {
    case right
    case down
    case left
    case up
}

class AZNPSPanGestureRecognizer: UIPanGestureRecognizer {
    
    let direction: NPSPanDirection = .right
    
    var dragging: Bool = false
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if self.state == .failed { return }
        
        let velocity = self.velocity(in: self.view)
        if !self.dragging && velocity != CGPoint.zero {
            let velocities: [NPSPanDirection : CGFloat] = [
                .right : velocity.x,
                .down : velocity.y,
                .left : -velocity.x,
                .up : -velocity.y,
            ]
//            let velocities: NSDictionary = [
//                NPSPanDirection.right : velocity.x,
//                NPSPanDirection.down : velocity.y,
//                NPSPanDirection.left : -velocity.x,
//                NPSPanDirection.up : -velocity.y,
//            ]
//            let keysSorted = velocities.keysSortedByValue(using: #selector())
//            let keysSorted: NSArray = velocities.keysSortedByValue(using: )
//            if keysSorted.lastObject.
            
//            let keysSorted: NSArray = []
            
//            if let object: NSString = keysSorted.lastObject as! NSString, object.integerValue != self.direction {
//                self.state = .failed
//            }
            
            let keysSorted = velocities.sorted(by: { $0.value < $1.value })
            
            print("velocities: \(velocities)")
            print("keysSorted: \(keysSorted)")
            
            self.dragging = true
        }
    }
    
    override func reset() {
        super.reset()
        self.dragging = false
    }
}
