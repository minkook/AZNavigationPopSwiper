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
        
        if state == .failed { return }
        
        let velocity = velocity(in: view)
        if !dragging && velocity != CGPoint.zero {
            let velocities: [NPSPanDirection : CGFloat] = [
                .right : velocity.x,
                .down : velocity.y,
                .left : -velocity.x,
                .up : -velocity.y,
            ]
            
            let keysSorted = velocities.sorted(by: { $0.value < $1.value })
            if let last = keysSorted.last, last.key != direction {
                state = .failed
            }
            
            dragging = true
        }
    }
    
    override func reset() {
        super.reset()
        dragging = false
    }
}
