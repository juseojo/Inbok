//
//  inform_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 3/26/24.
//

import Foundation
import UIKit
import SnapKit

class Inform_ViewController: UIViewController {

	var inform_view = Inform_view()

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.isNavigationBarHidden = true

		self.view.backgroundColor = UIColor(named: "BACKGROUND")
		inform_view.backgroundColor = UIColor(named: "BACKGROUND")

		//gradient color set
		let colors: [CGColor] = [
		   .init(red: 228/255, green: 75/255, blue: 66/255, alpha: 1),
		   .init(red: 233/255, green: 159/255, blue: 61/255, alpha: 0.53),
		   .init(red: 239/255, green: 255/255, blue: 55/255, alpha: 0.31)
		]
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = self.view.bounds
		gradientLayer.colors = colors
		gradientLayer.locations = [0.05, 0.15]
		inform_view.point_view.layer.insertSublayer(gradientLayer, at: 0)

		self.view.addSubview(inform_view)
		self.inform_view.snp.makeConstraints { (make) in
			make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		let url = URL(string: UserDefaults.standard.string(forKey: "profile_image") ?? "none")!
		DispatchQueue.global().async { [weak self] in
			if let data = try? Data(contentsOf: url) {
				if let image = UIImage(data: data) {
					DispatchQueue.main.async {
						self!.inform_view.profile_image.image = image
					}
				}
			}
		}
		inform_view.name_label.text = UserDefaults.standard.string(forKey: "name") ?? "none"
		inform_view.point_label.text = "point : " + (UserDefaults.standard.string(forKey: "point") ?? "none")
	}
}
