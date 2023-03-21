//
//  talk_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/03/22.
//

import UIKit
import SnapKit

class Talk_view: UIView {
    
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
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        top_view.addSubview(top_label)
        addSubview(top_view)
        
        top_view.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(head_height)
        }
        top_label.snp.makeConstraints{ (make) in
            make.top.equalTo(top_view).inset(7)
            make.left.equalTo(top_view).inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
