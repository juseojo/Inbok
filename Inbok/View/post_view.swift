//
//  post_view.swift
//  Inbok
//
//  Created by seongjun cho on 11/4/23.
//

import Foundation
import UIKit
import SnapKit

class Post_view : UIView {
    
    let head_view: UIView = {
        let head_view = UIView()
        
        let line: CALayer = CALayer()

        line.frame = CGRect(x: 0, y: head_height - 0.2, width: screen_width, height: 0.2)
        line.backgroundColor = UIColor.gray.cgColor
        head_view.layer.addSublayer(line)
        
        return head_view
    }()
    
    let back_btn: UIButton = {
        let back_btn = UIButton()
        
        back_btn.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        back_btn.tintColor = UIColor.gray
        
        return back_btn
    }()
    
    let title_label: UILabel = {
        let title_label = UILabel()
        title_label.textAlignment = .left
        title_label.minimumScaleFactor = 0.1
        title_label.numberOfLines = 0
        title_label.font = UIFont(name:"SeoulHangang", size: 50)
        title_label.adjustsFontSizeToFitWidth = true
        
        return title_label
    }()
    
    let problem_label:UILabel = {
        let problem_label = UILabel()
        
        problem_label.textAlignment = .left
        
        problem_label.minimumScaleFactor = 0.1
        problem_label.numberOfLines = 0
        problem_label.font = UIFont(name:"SeoulHangang", size: 25)
        
        return problem_label
    }()
    
    let scroll_view: UIScrollView = {
        let scroll_view = UIScrollView()

        return scroll_view
    }()
    
    let bottom_view: UIView = {
        let bottom_view = UIView()
        
        return bottom_view
    }()
    
    let line_view: UIView = {
        let line_view = UIView()
        line_view.backgroundColor = UIColor.gray
        
        return line_view
    }()
    
    let help_btn: UIButton = {
        let help_btn = UIButton()
        
        help_btn.setTitle("도와주기", for: .normal)
        help_btn.titleLabel!.font = UIFont(name:"SeoulHangang", size: 17)
        help_btn.backgroundColor = UIColor(named: "InBok_color")
        help_btn.layer.cornerRadius = 10
        return help_btn
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor(named:"BACKGROUND")
        
        addSubview(head_view)
        head_view.addSubview(back_btn)
        scroll_view.addSubview(title_label)
        scroll_view.addSubview(problem_label)
        addSubview(scroll_view)
        bottom_view.addSubview(line_view)
        bottom_view.addSubview(help_btn)
        addSubview(bottom_view)
        
        
        head_view.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(head_height)
        }
        
        back_btn.snp.makeConstraints{ (make) in
            make.top.equalTo(head_view).inset(3)
            make.left.equalTo(head_view).inset(15)
            make.bottom.equalTo(head_view).inset(3)
        }
        
        scroll_view.snp.makeConstraints{ (make) in
            make.top.equalTo(head_view.snp.bottom)
            make.left.right.equalTo(self)
            make.bottom.equalTo(bottom_view.snp.top)
        }
        title_label.snp.makeConstraints{ (make) in
            make.top.equalTo(scroll_view.snp.top)
            make.left.right.equalTo(self)
            make.height.equalTo(screen_height * 0.1)
        }
        problem_label.snp.makeConstraints{ (make) in
            make.top.equalTo(title_label.snp.bottom)
            make.left.right.equalTo(self)
            make.bottom.equalTo(scroll_view.snp.bottom)
        }
        
        bottom_view.snp.makeConstraints{ (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(screen_height * 0.07)
        }
        
        line_view.snp.makeConstraints{ (make) in
            make.top.right.left.equalTo(bottom_view)
            make.height.equalTo(0.5)
        }
        help_btn.snp.makeConstraints{ (make) in
            make.right.equalTo(bottom_view).inset(10)
            make.top.equalTo(bottom_view).inset(10)
            make.bottom.equalTo(bottom_view)
            make.width.equalTo(screen_width * 0.35)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
