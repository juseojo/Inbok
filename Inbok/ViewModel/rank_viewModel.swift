//
//  rank_viewModel.swift
//  Inbok
//
//  Created by seongjun cho on 3/25/24.
//

import Foundation
import UIKit
import Alamofire

class Rank_viewModel {

	var rank_model = Rank_model()

	func cell_setting(cell: Rank_cell, index: Int) -> Rank_cell
	{
		cell.selectionStyle = .none
		if (index == 0)
		{
			cell.rank.text = "\(rank_model.rankers[index]["rank"] ?? "none") (나)"
		}
		else
		{
			cell.rank.text = rank_model.rankers[index]["rank"] ?? "none"
		}
		cell.nick_name.text = rank_model.rankers[index]["name"]

		cell.rank.font = UIFont(name:"SeoulHangang", size: 20)
		cell.nick_name.font = UIFont(name:"SeoulHangang", size: 20)
		cell.rank.textColor = UIColor.black
		cell.nick_name.textColor = UIColor.black

		let url : URL! = URL(string: rank_model.rankers[index]["profile"] ?? "none")
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let imageData = data, response != nil, error == nil
			else {
				DispatchQueue.main.async {
					cell.profile.image = UIImage(systemName: "person.fill")
					cell.profile.tintColor = UIColor.systemGray
				}
				return
			}
			DispatchQueue.main.async {
				cell.profile.image = UIImage(data: imageData)
			}
		}.resume()

		return cell
	}

	func get_rankers()
	{
		let name = UserDefaults.standard.string(forKey: "name") ?? "none"
		
		let semaphore = DispatchSemaphore(value: 0)

		DispatchQueue.global(qos: .userInitiated).async
		{
			let session = URLSession.shared
			
			let url = URL(string: "http://\(host)/get_rankers?name=\(name)")
			var request = URLRequest(url: url!)
			request.httpMethod = "GET"
			session.dataTask(with: request){ data, response, error in
				guard error == nil else {
					print("Error: error calling GET")
					print(error!)
					return
				}
				guard let data = data else {
					print("Error: Did not receive data")
					return
				}
				guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
					print("Error: HTTP request failed")
					return
				}
				guard let output = try? JSONSerialization.jsonObject(with: data, options: []) else {
					print("json to Any Error")
					return
				}
				var rank_num: String
				var profile: String
				var ranker_name: String
				
				for ranker in output as! [[Any]]
				{
					if (ranker.isEmpty == false)
					{
						rank_num = String(describing: ranker[0])
						ranker_name = String(describing: ranker[1])
						profile = String(describing: ranker[2])
						self.rank_model.rankers.append(["rank" : rank_num, "name": ranker_name , "profile": profile])
					}
				}
				self.rank_model.rankers.delete_firstNil()
				semaphore.signal()
			}.resume()
		}
		semaphore.wait()
	}
}
