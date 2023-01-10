//
//  ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let need_bok_view = Need_bok()

        self.view.addSubview(need_bok_view)
        
        need_bok_view.snp.makeConstraints{ (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}

