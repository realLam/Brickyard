//
//  ViewController.swift
//  Demo
//
//  Created by lam on 2019/9/1.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.bk_placeholder = "thx"
        textView.bk_maxWordCount = 50
        
        
        btn.bk_addTarget { (btn) in
            print(btn)
        }
    }

    
    
}

