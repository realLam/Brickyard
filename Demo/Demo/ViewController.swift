//
//  ViewController.swift
//  Demo
//
//  Created by lam on 2019/9/1.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
//import Brickyard

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.bk_placeholder = "iOS中, 控件的布局方式有两种, 一种是通过"
        textView.bk_maxWordCount = 50
        
        
        
        btn.bk_addTarget { (btn) in
            print(btn)
        }
        
//        let img = UIImage.bk_image(fromVideoUrl: URL(fileURLWithPath: "/Users/lam/Downloads/IMG_0105.MOV"))
//        let iv = UIImageView.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.image = img
//        view.addSubview(iv)
        
    }

    
    
}

