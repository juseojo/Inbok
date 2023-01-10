//
//  View.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import UIKit

let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
class Need_bok: UIView {
    
    var top_view: UIView = {
        let top_view = UIView(frame: CGRect(x: 0, y: screen_height * 0.075, width: screen_width, height: 50))

        let nameLabel: UILabel = {
                let nameLabel = UILabel()
                nameLabel.textAlignment = .left
                nameLabel.textColor = .black
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.text = "당신은 누군가의 인복"
                nameLabel.font = UIFont(name:"SeoulHangang", size: 20)
                
                override func drawTextInRect(rect: CGRect) {
                    var insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
                    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
                }
                return nameLabel
        }()
        top_view.addSubview(nameLabel)
        
        return top_view
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
        addSubview(top_view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
