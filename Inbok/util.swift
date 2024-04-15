//
//  util.swift
//  Inbok
//
//  Created by seongjun cho on 2023/06/19.
//

import Foundation
import UIKit
import Alamofire

let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
let head_height: CGFloat = screen_height * 0.05
let top_inset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
let bottom_inset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0

let date_formatter :DateFormatter = {
    
    let date_formatter = DateFormatter()
    
    date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    date_formatter.locale = Locale(identifier: "ko_kr")
    date_formatter.timeZone = TimeZone(abbreviation: "KST")
    
    return date_formatter
}()

func time_diff(past_date:Date) -> Int
{
    let now_date = Date()
    let diff = Int(now_date.timeIntervalSince(past_date))/60
    
    return diff
}

func get_user_inform(name : String,  closure: @escaping ([String: String]) -> Void)
{
	AF.request("http://\(host)/user_inform",
               method: .get,
               parameters: ["name" :name],
               encoding: URLEncoding.default,
               headers: ["Content-Type":"application/json", "Accept":"application/json"])
    .validate(statusCode: 200..<300)
    .responseJSON { response in
        switch response.result {
		case .success:
			if let data = try! response.result.get() as? [Any]
			{
				var result = [ "name" : String(describing: data[0]),
							   "id" : String(describing: data[1]),
							   "profile_image": String(describing: data[2]),
							   "point": String(describing: data[3]),
							   "mail": String(describing: data[4])]
				closure(result)
			}
		case .failure(let error):
            print(error)
        }
    }
}

func save_image(url_string: String, name: String)
{
	if (name == "none" || name == "nil" )
	{
		return
	}
	let url : URL! = URL(string: url_string)
	URLSession.shared.dataTask(with: url) { (data, response, error) in
		guard let imageData = data
		else {
			print("save_profile_fail")
			return
		}
		do {
			let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			let url = directory.appendingPathComponent("\(name).png")
			try imageData.write(to: url)
		}
		catch {
			print("fail to write data to disk / \(error)")
		}
	}.resume()
}

func load_image(name: String) -> UIImage?
{
	if (name == "none" || name == "nil" )
	{
		return UIImage(systemName: "person.fill")
	}
	
	do {
		let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		let profile = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("\(name).png").path)
		if (profile == nil)
		{
			return UIImage(systemName: "person.fill")
		}

		return profile

	} catch {
		print("\(error)")
	}
	
	return UIImage(systemName: "person.fill")
}



extension [[String:String]] {
    mutating func delete_firstNil()
    {
        if (!self.isEmpty)
        {
            if (self[0].isEmpty)
            {
                self.remove(at: 0)
            }
        }
    }
}
