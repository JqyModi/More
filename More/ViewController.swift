//
//  ViewController.swift
//  More
//
//  Created by Modi on 2019/6/3.
//  Copyright © 2019年 modi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        print(identifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue)
        let vc: LongDrageViewController = segue.destination as! LongDrageViewController
        
        if let identifier = segue.identifier {
            if identifier == "Car" {
                vc.type = 0
            }else if identifier == "Ship" {
                vc.type = 1
            }
        }
    }
    
}

