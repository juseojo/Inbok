//
//  View.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import UIKit

let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
class Need_bok_view: UIView {
    
    let top_view: UIView = {
        let top_view = UIView(frame: CGRect(x: 0, y: screen_height * 0.075, width: screen_width, height: 50))
        top_view.bounds = top_view.frame.insetBy(dx: 10.0, dy: 0)
        
        return top_view
    }()
    
    let top_label: UILabel = {
        let top_label = UILabel()
        top_label.textAlignment = .left
        top_label.textColor = .black
        top_label.translatesAutoresizingMaskIntoConstraints = false
        top_label.font = UIFont(name:"SeoulHangang", size: 20)
        
        return top_label
    }()
    
    override func draw(_ rect: CGRect) {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: super.frame.height))
            path.addLine(to: CGPoint(x: 10, y: super.frame.height))
            //path.lineWidth = 1
            path.close()
            //path.stroke()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        top_view.addSubview(top_label)
        addSubview(top_view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
