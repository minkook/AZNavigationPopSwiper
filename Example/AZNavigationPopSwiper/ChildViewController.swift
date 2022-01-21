//
//  ChildViewController.swift
//  AZNavigationPopSwiper_Example
//
//  Created by minkook yoo on 2022/01/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ChildViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    func setUpView() {
        guard let nc = self.navigationController else { return }
        
        let count = nc.viewControllers.count
        
        if count == 1 {
            self.view.backgroundColor = UIColor.lightGray
        } else {
            let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .brown, .purple]
            let index = (count - 2) % colors.count
            self.view.backgroundColor = colors[index]
        }
    }
    
    @IBAction func pushButtonAction(_ sender: Any) {
        guard let nc = self.navigationController else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildViewController")
        nc.pushViewController(vc, animated: true)
    }
    
}
