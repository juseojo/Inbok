//
//  View.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import UIKit
import SnapKit

let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
let head_height: CGFloat = screen_height * 0.05

class Need_bok_view: UIView {
    
    let top_view: UIView = {
        let top_view = UIView()
        
        let line: CALayer = CALayer()

        line.frame = CGRect(x: 0, y: head_height - 0.2, width: screen_width, height: 0.2)
        line.backgroundColor = UIColor.gray.cgColor
        top_view.layer.addSublayer(line)
        
        return top_view
    }()
    
    let top_label: UILabel = {
        let top_label = UILabel()
        top_label.textAlignment = .left
        top_label.textColor = .black
        top_label.font = UIFont(name:"SeoulHangang", size: 20)
        
        return top_label
    }()
    
    let top_btn: UIButton = {
        let top_btn = UIButton()
        
        top_btn.setImage(UIImage(named: "edit_document"), for: .normal)
        return top_btn
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        top_view.addSubview(top_label)
        top_view.addSubview(top_btn)
        addSubview(top_view)
        
        top_view.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(head_height)
        }
        top_label.snp.makeConstraints{ (make) in
            make.top.equalTo(top_view).inset(7)
            make.left.equalTo(top_view).inset(18)
        }
        top_btn.snp.makeConstraints{ (make) in
            make.top.equalTo(top_view).inset(3)
            make.right.equalTo(top_view).inset(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
