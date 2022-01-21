//
//  ViewController.swift
//  AZNavigationPopSwiper
//
//  Created by minkook on 01/21/2022.
//  Copyright (c) 2022 minkook. All rights reserved.
//

import UIKit
import AZNavigationPopSwiper

class ViewController: UIViewController {
    
    var navigationPopSwiper: AZNavigationPopSwiper?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildViewController")
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        
        if let popGuesture = nc.interactivePopGestureRecognizer {
            popGuesture.isEnabled = false
        }
        
        self.navigationPopSwiper = AZNavigationPopSwiper(navigationController: nc)
        
        self.present(nc, animated: true, completion: nil)
    }
}

