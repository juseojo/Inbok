//
//  rank_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 3/23/24.
//

import Foundation
import UIKit
import SnapKit
class Rank_ViewController: UIViewController {
	
	var rank_view = Rank_view()
	var rank_viewModel = Rank_viewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor(named: "BACKGROUND")

		navigationController?.isNavigationBarHidden = true
		
		rank_view.rank_tableView.delegate = self
		rank_view.rank_tableView.dataSource = self

		//gradient color set
		let colors: [CGColor] = [
		   .init(red: 228/255, green: 75/255, blue: 66/255, alpha: 1),
		   .init(red: 233/255, green: 159/255, blue: 61/255, alpha: 0.53),
		   .init(red: 239/255, green: 255/255, blue: 55/255, alpha: 0.31)
		]
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = self.view.bounds
		gradientLayer.colors = colors
		gradientLayer.locations = [0.4, 0.6]

		rank_view.body_view.layer.insertSublayer(gradientLayer, at: 0)

		self.view.addSubview(rank_view)

		self.rank_view.snp.makeConstraints { (make) in
			make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		//get rankers inform to server
		rank_viewModel.get_rankers()
		
		
		
		var rankers_profile = [ URL(string: rank_viewModel.rank_model.rankers[1]["profile"] ?? "none")!,
								URL(string: rank_viewModel.rank_model.rankers[2]["profile"] ?? "none")!,
								URL(string: rank_viewModel.rank_model.rankers[3]["profile"] ?? "none")!]

		
		var count = 0
		for url in rankers_profile
		{
			URLSession.shared.dataTask(with: url) { (data, response, error) in
				guard let imageData = data
				else {
					DispatchQueue.main.async {
						switch count{
						case 0:
							self.rank_view.first_image_view.profile_image_view.image = UIImage(systemName: "person.fill")
						case 1:
							self.rank_view.second_image_view.profile_image_view.image = UIImage(systemName: "person.fill")
						case 2:
							self.rank_view.third_image_view.profile_image_view.image = UIImage(systemName: "person.fill")
						default:
							print("rankers_profile error")
						}
					}
					return
				}
				DispatchQueue.main.async {
					switch count{
					case 0:
						self.rank_view.first_image_view.profile_image_view.image = UIImage(data: imageData)
					case 1:
						self.rank_view.second_image_view.profile_image_view.image = UIImage(data: imageData)
					case 2:
						self.rank_view.third_image_view.profile_image_view.image = UIImage(data: imageData)
					default:
						print("rankers_profile error")
					}
				}
				count += 1
			}.resume()
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		//get rankers inform to server
		rank_viewModel.rank_model.rankers.removeAll()
	}
}

//for rank_cell
extension Rank_ViewController: UITableViewDataSource, UITableViewDelegate {
	
	//rank_num
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
	-> Int
	{
		return 6
	}
	
	//make_cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
	-> UITableViewCell
	{
		var cell =  rank_view.rank_tableView.dequeueReusableCell(
			withIdentifier: Rank_cell.cell_id,
			for: indexPath
		) as! Rank_cell

		cell.backgroundColor = UIColor.white
		
		cell  = self.rank_viewModel.cell_setting(
			cell: cell,
			index: indexPath.row
		)

		return cell
	}
}
