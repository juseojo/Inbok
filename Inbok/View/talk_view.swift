//
//  talk_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/03/22.
//

import UIKit
import SnapKit

class Talk_view: UIView {
    
    let head_view: UIView = {
        let head_view = UIView()
        
        let line: CALayer = CALayer()

        line.frame = CGRect(x: 0, y: head_height - 0.2, width: screen_width, height: 0.2)
        line.backgroundColor = UIColor.gray.cgColor
        head_view.layer.addSublayer(line)
        
        return head_view
    }()
    
    let head_label: UILabel = {
        let head_label = UILabel()
        head_label.textAlignment = .left
        head_label.textColor = .black
        head_label.font = UIFont(name:"SeoulHangang", size: 20)
        
        return head_label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        head_view.addSubview(head_label)
        addSubview(head_view)
        
        head_view.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(head_height)
        }
        head_label.snp.makeConstraints{ (make) in
            make.top.equalTo(head_view).inset(7)
            make.left.equalTo(head_view).inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
