//
//  writePost_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/08/28.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

class WritePost_view: UIView {
    
    
    var title_field : UITextField = {
        var title_field = UITextField()
        
        title_field.backgroundColor = .systemGray2
        title_field.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name:"SeoulHangang", size: 20)])
        title_field.layer.cornerRadius = 10
        title_field.addLeftPadding()
 
        return title_field
    }()
    
    var content_field : UITextField = {
        var title_field = UITextField()
        
        title_field.backgroundColor = .systemGray2
        title_field.attributedPlaceholder = NSAttributedString(string: "고민 내용을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name:"SeoulHangang", size: 20)])
        title_field.layer.cornerRadius = 10
        title_field.addLeftPadding()
 
        return title_field
    }()
    
    var write_btn : UIButton = {
        var write_btn = UIButton()
        
        write_btn.setTitle("확인", for: .normal)
        write_btn.backgroundColor = UIColor(named: "InBok_color")
        write_btn.layer.cornerRadius = 10
        write_btn.titleLabel?.font = UIFont(name:"SeoulHangang", size: 20)
        write_btn.addTarget(self, action: #selector(write_btn_click(_:)), for: .touchUpInside)
        
        return write_btn
    }()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(title_field)
        addSubview(content_field)
        addSubview(write_btn)
        
        self.snp.makeConstraints{ (make) in
            make.top.equalTo(self)
            make.height.equalTo(screen_height)
            make.width.equalTo(screen_width)
        }
        
        title_field.snp.makeConstraints{ (make) in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalTo(self).inset(10)
            make.height.equalTo(screen_height * 0.1)
        }
        write_btn.snp.makeConstraints{ (make) in
            make.height.equalTo(screen_height * 0.1)
            make.left.right.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
        content_field.snp.makeConstraints{ (make) in
            make.top.equalTo(title_field.snp.bottom).inset(-10)
            make.left.right.equalTo(self).inset(10)
            make.bottom.equalTo(write_btn.snp.top).inset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }

    @objc func write_btn_click(_ sender : UIButton)
    {
        print("Write button click\n")
        var vc = self.window?.rootViewController?.presentedViewController
        
        if (title_field.text == Optional(""))
        {
            print("title nil")
            let alert = UIAlertController(title: "알림", message: "제목을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            vc?.present(alert, animated: false, completion: nil)
            
            return ;
        }
        else if (content_field.text == Optional(""))
        {
            print("content nil")
            let alert = UIAlertController(title: "알림", message: "내용을  입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            vc?.present(alert, animated: false, completion: nil)
            
            return ;
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        let paramaters = ["name": UserDefaults.standard.string(forKey: "name")!,
                          "title": title_field.text!,
                          "content": content_field.text!,
                          "time": formatter.string(from: date),
                          "profile_image": UserDefaults.standard.string(forKey: "profile_image")!] as [String : String]
        
        AF.request("http://\(host)/write", method: .post, parameters: paramaters, encoding: URLEncoding.httpBody).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: String] {
                    if (data["result"] == "success")
                    {
                        print("write success")
                        self.window?.rootViewController?.dismiss(animated: true)
                    }
                    else
                    {
                        print("register fail")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
