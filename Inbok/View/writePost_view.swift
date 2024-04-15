//
//  writePost_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/08/28.
//

import UIKit

import SnapKit


class WritePost_view: UIView {

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
	
    var title_field : UITextField = {
        var title_field = UITextField()
        
        title_field.backgroundColor = .systemGray2
        title_field.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name:"SeoulHangang", size: 20)!])
        title_field.layer.cornerRadius = 10
		title_field.font = UIFont(name:"SeoulHangang", size: 25)
        title_field.addLeftPadding()
 
        return title_field
    }()
    
    var content_text_view : UITextView = {
        var content_text_view = UITextView()
        
		content_text_view.backgroundColor = .systemGray2
		content_text_view.layer.cornerRadius = 10
		content_text_view.text = "고민 내용을 입력해주세요."
		content_text_view.textColor = .white
		content_text_view.font = UIFont(name:"SeoulHangang", size: 20)

        return content_text_view
    }()
    
    var write_btn : UIButton = {
        var write_btn = UIButton()
        
        write_btn.setTitle("확인", for: .normal)
        write_btn.backgroundColor = UIColor(named: "INBOK")
        write_btn.layer.cornerRadius = 10
        write_btn.titleLabel?.font = UIFont(name:"SeoulHangang", size: 20)
        
        return write_btn
    }()

	var point_image : UIImageView = {
		var point_image = UIImageView()
		
		point_image.image = UIImage(named: "help")
		point_image.contentMode = .scaleAspectFit
		
		return point_image
	}()
	
	var point_label : UILabel = {
		var point_label = UILabel()
		
		point_label.text = ": 1"
		point_label.font = UIFont(name:"SeoulHangang", size: 20)
		
		return point_label
	}()
	
	var point_up_btn : UIButton = {
		var point_up_btn = UIButton()
		
		point_up_btn.setImage(UIImage(systemName: "arrowshape.up"), for: .normal)
		
		point_up_btn.tintColor = UIColor(named: "REVERSE_SYS")
		
		return point_up_btn
	}()
	
	var point_down_btn : UIButton = {
		var point_down_btn = UIButton()
		
		point_down_btn.setImage(UIImage(systemName: "arrowshape.down"), for: .normal)
		point_down_btn.tintColor = UIColor(named: "REVERSE_SYS")

		
		return point_down_btn
	}()
	
	var bottom_view : UIView = {
		var bottom_view = UIView()
		
		return bottom_view
	}()
	
    override init(frame: CGRect) {
        
        super.init(frame: frame)

		addSubview(head_view)
		head_view.addSubview(back_btn)
		
        addSubview(title_field)
        addSubview(content_text_view)
		
		addSubview(bottom_view)
		bottom_view.addSubview(write_btn)
		bottom_view.addSubview(point_image)
		bottom_view.addSubview(point_label)
		bottom_view.addSubview(point_up_btn)
		bottom_view.addSubview(point_down_btn)
		
        self.snp.makeConstraints{ (make) in
            make.top.equalTo(self)
            make.height.equalTo(screen_height)
            make.width.equalTo(screen_width)
        }

		head_view.snp.makeConstraints{ (make) in
			make.top.equalTo(safeAreaLayoutGuide)
			make.width.equalTo(self.snp.width)
			make.height.equalTo(head_height)
		}
		
		back_btn.snp.makeConstraints{ (make) in
			make.top.equalTo(head_view).inset(3)
			make.left.equalTo(head_view).inset(15)
			make.bottom.equalTo(head_view).inset(3)
		}

        title_field.snp.makeConstraints{ (make) in
			make.height.equalTo(screen_height * 0.1)
			make.top.equalTo(head_view.snp.bottom).inset(-10)
            make.left.right.equalTo(self).inset(20)
        }
		content_text_view.snp.makeConstraints{ (make) in
			make.top.equalTo(title_field.snp.bottom).inset(-10)
			make.left.right.equalTo(self).inset(20)
			make.bottom.equalTo(bottom_view.snp.top).inset(-10)
		}

		bottom_view.snp.makeConstraints{ (make) in
			make.height.equalTo(screen_height * 0.05)
			make.bottom.equalTo(self).inset(bottom_inset)
			make.left.right.equalTo(self).inset(20)
		}
		point_image.snp.makeConstraints{ (make) in
			make.left.bottom.top.equalTo(bottom_view)
        }
		point_label.snp.makeConstraints{ (make) in
			make.top.bottom.equalTo(bottom_view)
			make.left.equalTo(point_image.snp.right)
		}
		point_up_btn.snp.makeConstraints{ (make) in
			make.top.bottom.equalTo(bottom_view)
			make.left.equalTo(point_label.snp.right).inset(-20)
		}
		
		point_down_btn.snp.makeConstraints{ (make) in
			make.top.bottom.equalTo(bottom_view)
			make.left.equalTo(point_up_btn.snp.right).inset(-20)
		}
		
		write_btn.snp.makeConstraints{ (make) in
			make.right.bottom.top.equalTo(bottom_view)
			make.left.equalTo(point_down_btn.snp.right).inset(-20)
			make.width.greaterThanOrEqualTo(50)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
