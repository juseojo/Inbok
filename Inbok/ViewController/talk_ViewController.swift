//
//  talk_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/01/28.
//

import UIKit

class talk_ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hi = UILabel()
        
        hi.text = "hi I'M talk"
        
        self.view.addSubview(hi)
    }
}
